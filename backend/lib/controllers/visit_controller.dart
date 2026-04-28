import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_firebase_admin/firestore.dart';

class VisitController {
  final Firestore firestore;
  VisitController(this.firestore);

  Router get router {
    final router = Router();
    router.post('/add', (Request request) async {
      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        final userId = data['userId'];

        final docRef = await firestore
            .collection('users')
            .doc(userId)
            .collection('visits')
            .add({
          'doctorName': data['doctorName'],
          'specialty': data['specialty'],
          'date': data['date'], 
          'notes': data['notes'],
          'createdAt': FieldValue.serverTimestamp,
        });

        return Response.ok(jsonEncode({'status': 'success', 'id': docRef.id}));
      } catch (e) {
        return Response.internalServerError(body: 'Error adding visit: $e');
      }
    });

    router.get('/list/<userId>', (Request request, String userId) async {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('visits')
            .orderBy('date', descending: true) 
            .get();

        final visits = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data.remove('createdAt'); 
          return {'id': doc.id, ...data};
        }).toList();

        return Response.ok(jsonEncode(visits), headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(body: 'Error fetching visits: $e');
      }
    });

    return router;
  }
}
