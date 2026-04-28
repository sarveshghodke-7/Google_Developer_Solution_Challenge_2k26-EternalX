import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import '../lib/core/firebase_setup.dart';
import '../lib/core/auth_middleware.dart';
import '../lib/controllers/report_controller.dart';
import '../lib/controllers/medication_controller.dart';
import '../lib/controllers/visit_controller.dart';
import '../lib/controllers/trend_controller.dart';
import '../lib/controllers/campaign_controller.dart';

void main(List<String> args) async {
  try {
    await AppSetup.initialize();
  } catch (e) {
    print(e);
    return; 
  }

  final reportController = ReportController(AppSetup.firestore);
  final medicationController = MedicationController(AppSetup.firestore);
  final visitController = VisitController(AppSetup.firestore);
  final trendController = TrendController(AppSetup.firestore);
  final campaignController = CampaignController(AppSetup.firestore);
  final appRouter = Router()
    ..mount('/', reportController.router) 
    ..mount('/meds', medicationController.router)
    ..mount('/visits', visitController.router)
    ..mount('/trends', trendController.router)
    ..mount('/campaigns', campaignController.router); 

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) => (request) async {
        final response = await innerHandler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        });
      })
      .addMiddleware(authMiddleware())
      .addHandler(appRouter.call);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(AppSetup.env['PORT'] ?? '8080'); 
  final server = await serve(handler, ip, port);
  
  print('Dart Backend running at http://${server.address.host}:${server.port}');
}
