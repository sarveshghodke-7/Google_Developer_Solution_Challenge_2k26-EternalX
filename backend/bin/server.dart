import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Import your custom files
import '../lib/core/firebase_setup.dart';
import '../lib/controllers/report_controller.dart';
import '../lib/controllers/medication_controller.dart';

void main(List<String> args) async {
  try {
    await AppSetup.initialize();
  } catch (e) {
    print(e);
    return; 
  }

  final reportController = ReportController(AppSetup.firestore);
  final medicationController = MedicationController(AppSetup.firestore);

  final appRouter = Router()
    ..mount('/', reportController.router)         // Mounts /analyze-report
    ..mount('/meds', medicationController.router); // Mounts /meds/add, /meds/list

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) => (request) async {
        final response = await innerHandler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      })
      .addHandler(appRouter.call);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(AppSetup.env['PORT'] ?? '8080'); 
  final server = await serve(handler, ip, port);
  
  print('Dart Backend running at http://${server.address.host}:${server.port}');
}
