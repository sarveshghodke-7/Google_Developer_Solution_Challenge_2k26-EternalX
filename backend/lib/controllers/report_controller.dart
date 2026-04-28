import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_firebase_admin/firestore.dart';
import '../core/firebase_setup.dart';

class ReportController {
  final Firestore firestore;

  ReportController(this.firestore);

  static const _promptText = '''
You are a medical data extraction assistant. 
Analyze this medical report and return the data strictly in Token-Oriented Object Notation (TOON).
Always provide at least 3 general health recommendations based on the identified alerts.
Do not use JSON. Do not include markdown formatting. 
Output exactly matching this structure:

<ALERTS>
[title="High Cholesterol" severity="high" description="..."]
</ALERTS>

<PARAMETERS>
[name="LDL" value="160" unit="mg/dL" status="high"]
</PARAMETERS>

<RECOMMENDATIONS>
[text="Eat less saturated fat"]
</RECOMMENDATIONS>
''';

  Router get router {
    final router = Router();

    router.post('/analyze-report', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        
        final String base64File = data['fileBytes'];
        final String mimeType = data['mimeType']; 
        final fileBytes = base64Decode(base64File);
        final fileHash = sha256.convert(fileBytes).toString();
        print('Checking cache for hash: $fileHash');
        final userId = request.context['userId'] as String?;
        
        final cacheRef = firestore.collection('report_cache').doc(fileHash);
        final cachedDoc = await cacheRef.get();
        
        if (cachedDoc.exists) {
          print('CACHE HIT: Returning stored TOON data.');
          final cachedToon = cachedDoc.data()?['toon_output'] as String;
          return Response.ok(cachedToon, headers: {'Content-Type': 'text/plain'});
        }
        print('CACHE MISS: Calling Gemini...');
        final model = GenerativeModel(
          model: 'gemini-2.5-flash', 
          apiKey: AppSetup.geminiApiKey,
        );

        final content = [
          Content.multi([
            TextPart(_promptText),
            DataPart(mimeType, fileBytes),
          ])
        ];

        final response = await model.generateContent(content);
        final aiOutput = response.text ?? '';
        print('Received fresh data from Gemini!');

        await cacheRef.set({
          'hash': fileHash,
          'toon_output': aiOutput,
          'created_at': FieldValue.serverTimestamp,
        });

        if (userId != null) {
          await firestore.collection('users').doc(userId).collection('reports').add({
            'hash': fileHash,
            'toon_output': aiOutput,
            'createdAt': FieldValue.serverTimestamp,
          });
        }

        return Response.ok(aiOutput, headers: {'Content-Type': 'text/plain'});

      } catch (e) {
        print('Error: $e');
        return Response.internalServerError(body: e.toString());
      }
    });

    router.get('/list/<userId>', (Request request, String userId) async {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('reports')
            .orderBy('createdAt', descending: true)
            .get();

        final List<Map<String, dynamic>> reportsList = [];
        
        for (var doc in snapshot.docs) {
          final docData = doc.data() as Map<String, dynamic>;
          // Remove timestamp to avoid JSON encoding issues
          docData.remove('createdAt'); 
          reportsList.add({
            'id': doc.id,
            ...docData,
          });
        }

        return Response.ok(
          jsonEncode(reportsList), 
          headers: {'Content-Type': 'application/json'}
        );
      } catch (e) {
        print('❌ Get Reports Error: $e');
        return Response.internalServerError(body: 'Error fetching reports: $e');
      }
    });

    return router;
  }
}
