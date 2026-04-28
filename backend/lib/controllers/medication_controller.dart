import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_firebase_admin/firestore.dart';

class MedicationController {
  final Firestore firestore;

  MedicationController(this.firestore);

  Router get router {
    final router = Router();

    router.post('/add', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);

        final userId = data['userId'];
        if (userId == null || userId.isEmpty) {
          return Response.badRequest(body: 'Missing userId');
        }
        
        final docRef = await firestore
            .collection('users')
            .doc(userId)
            .collection('medications')
            .add({
          'name': data['name'],
          'dosage': data['dosage'],
          'frequency': data['frequency'],
          'reminderTime': data['reminderTime'], 
          'createdAt': FieldValue.serverTimestamp,
        });

        return Response.ok(
          jsonEncode({
            'status': 'success', 
            'message': 'Medication added',
            'medId': docRef.id 
          }),
          headers: {'Content-Type': 'application/json'}
        );
      } catch (e) {
        print('❌ Add Med Error: $e');
        return Response.internalServerError(body: 'Error adding med: $e');
      }
    });

    router.get('/list/<userId>', (Request request, String userId) async {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('medications')
            .get();

        final List<Map<String, dynamic>> medsList = [];
        
        for (var doc in snapshot.docs) {
          final docData = doc.data() as Map<String, dynamic>;
          
          docData.remove('createdAt'); 
          
          medsList.add({
            'id': doc.id,
            ...docData,
          });
        }

        return Response.ok(
          jsonEncode(medsList), 
          headers: {'Content-Type': 'application/json'}
        );
      } catch (e) {
        print('❌ Get Meds Error: $e');
        return Response.internalServerError(body: 'Error fetching meds: $e');
      }
    });

    router.delete('/remove/<userId>/<medId>', (Request request, String userId, String medId) async {
      try {
        await firestore
            .collection('users')
            .doc(userId)
            .collection('medications')
            .doc(medId)
            .delete();

        return Response.ok(jsonEncode({'status': 'deleted'}));
      } catch (e) {
        return Response.internalServerError(body: 'Error deleting med');
      }
    });

    return router;
  }
}
