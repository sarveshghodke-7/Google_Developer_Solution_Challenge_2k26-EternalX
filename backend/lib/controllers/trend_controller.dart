import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dart_firebase_admin/firestore.dart';
import '../core/firebase_setup.dart';

class TrendController {
  final Firestore firestore;
  TrendController(this.firestore);

  static const _trendPrompt = '''
You are an expert medical AI. Analyze the following historical medical data for a patient.
Identify exactly 3 key health trends over time (e.g., improvements, declines, or stable but abnormal values).
Return the output STRICTLY in Token-Oriented Object Notation (TOON). Do not use JSON.
Format exactly like this:

<TRENDS>
[title="Improving Cholesterol" status="positive" description="Your LDL dropped over the last 3 months."]
[title="Vitamin D Low" status="negative" description="Your Vitamin D remains below normal limits."]
</TRENDS>
''';

  Router get router {
    final router = Router();

    router.get('/analyze/<userId>', (Request request, String userId) async {
      try {
        final reportsSnapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('reports')
            .orderBy('createdAt', descending: true)
            .get();

        final reportCount = reportsSnapshot.docs.length;

        if (reportCount == 0) {
          return Response.ok('<TRENDS></TRENDS>', headers: {'Content-Type': 'text/plain'});
        }

        final cacheRef = firestore.collection('users').doc(userId).collection('cache').doc('trends');
        final cacheDoc = await cacheRef.get();

        if (cacheDoc.exists) {
          final cacheData = cacheDoc.data()!;
          if (cacheData['reportCount'] == reportCount) {
            print('⚡ CACHE HIT: Returning saved trends for $reportCount reports.');
            return Response.ok(cacheData['toon_output'], headers: {'Content-Type': 'text/plain'});
          }
        }

        print('CACHE MISS: Analyzing $reportCount reports...');
        String historyData = "PATIENT HISTORY (Newest to Oldest):\n\n";
        for (var doc in reportsSnapshot.docs.take(5)) { //limit 5
          final data = doc.data() as Map<String, dynamic>;
          historyData += "Report:\n${data['toon_output']}\n\n";
        }

        final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: AppSetup.geminiApiKey);
        final response = await model.generateContent([Content.text(_trendPrompt + "\n\n" + historyData)]);
        final aiOutput = response.text ?? '<TRENDS></TRENDS>';

        await cacheRef.set({
          'reportCount': reportCount,
          'toon_output': aiOutput,
          'updatedAt': FieldValue.serverTimestamp,
        });

        return Response.ok(aiOutput, headers: {'Content-Type': 'text/plain'});
      } catch (e) {
        return Response.internalServerError(body: 'Error: $e');
      }
    });

    router.get('/report-count/<userId>', (Request request, String userId) async {
      try {
        final snapshot = await firestore.collection('users').doc(userId).collection('reports').get();
        return Response.ok('{"count": ${snapshot.docs.length}}', headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(body: 'Error');
      }
    });

    return router;
  }
}
