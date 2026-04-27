import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dotenv/dotenv.dart'; 

const promptText = '''
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

final router = Router()
  ..post('/analyze-report', _analyzeReportHandler);

late DotEnv env; 

Future<Response> _analyzeReportHandler(Request request) async {
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);
    
    final String base64File = data['fileBytes'];
    final String mimeType = data['mimeType']; 
    final fileBytes = base64Decode(base64File);
    final apiKey = env['GEMINI_API_KEY']; 
    
    if (apiKey == null || apiKey.isEmpty) {
      return Response.internalServerError(body: 'Server missing GEMINI_API_KEY in .env file');
    }

    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

    final content = [
      Content.multi([
        TextPart(promptText),
        DataPart(mimeType, fileBytes),
      ])
    ];

    print('Sending file to Gemini...');
    final response = await model.generateContent(content);
    print('Received data from Gemini!');
    
    print('AI Output:\n${response.text}');

    return Response.ok(
      response.text, 
      headers: {'Content-Type': 'text/plain'},
    );

  } catch (e) {
    print('Error: $e');
    return Response.internalServerError(body: e.toString());
  }
}

void main(List<String> args) async {
  env = DotEnv(includePlatformEnvironment: true)..load();
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(env['PORT'] ?? '8080'); 

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
      .addHandler(router.call);

  final server = await serve(handler, ip, port);
  print('Dart Backend running at http://${server.address.host}:${server.port}');
}
