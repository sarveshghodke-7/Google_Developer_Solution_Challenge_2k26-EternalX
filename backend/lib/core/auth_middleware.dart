import 'package:shelf/shelf.dart';
import 'firebase_setup.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // OPTIONS requests should be passed through for CORS
      if (request.method == 'OPTIONS') {
        return innerHandler(request);
      }

      final authHeader = request.headers['authorization'] ?? request.headers['Authorization'];
      
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(401, body: 'Missing or invalid Authorization header');
      }

      final token = authHeader.substring(7);

      try {
        final decodedToken = await AppSetup.auth.verifyIdToken(token);
        // We can add the user to the request context
        final updatedRequest = request.change(context: {'userId': decodedToken.uid});
        return innerHandler(updatedRequest);
      } catch (e) {
        return Response(401, body: 'Unauthorized: Invalid token');
      }
    };
  };
}
