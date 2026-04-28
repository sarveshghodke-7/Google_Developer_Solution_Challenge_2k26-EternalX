import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_firebase_admin/firestore.dart';

class CampaignController {
  final Firestore firestore;

  CampaignController(this.firestore);

  Router get router {
    final router = Router();

    // Fetch campaigns
    router.get('/list/<userId>', (Request request, String userId) async {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .get();

        final List<Map<String, dynamic>> campaigns = [];
        for (var doc in snapshot.docs) {
          final docData = doc.data() as Map<String, dynamic>;
          docData['id'] = doc.id;
          campaigns.add(docData);
        }

        return Response.ok(
          jsonEncode(campaigns), 
          headers: {'Content-Type': 'application/json'}
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error fetching campaigns: $e');
      }
    });

    // Add campaign
    router.post('/add', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);

        final userId = request.context['userId'] as String?;
        if (userId == null) return Response.badRequest(body: 'Missing userId');
        
        final docRef = await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .add({
          'title': data['title'],
          'description': data['description'],
          'daysTotal': data['daysTotal'],
          'daysCompleted': data['daysCompleted'] ?? 0,
          'isActive': data['isActive'] ?? true,
          'category': data['category'] ?? 'Custom',
        });

        return Response.ok(
          jsonEncode({'status': 'success', 'id': docRef.id}),
          headers: {'Content-Type': 'application/json'}
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error adding campaign: $e');
      }
    });

    // Toggle active state or update progress
    router.put('/update/<campaignId>', (Request request, String campaignId) async {
      try {
        final userId = request.context['userId'] as String?;
        if (userId == null) return Response.badRequest(body: 'Missing userId');

        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        
        await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .doc(campaignId)
            .update(data);

        return Response.ok(jsonEncode({'status': 'updated'}));
      } catch (e) {
        return Response.internalServerError(body: 'Error updating campaign: $e');
      }
    });

    return router;
  }
}
