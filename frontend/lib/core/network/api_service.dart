import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/report_analyzer/data/report_insight_model.dart';
import 'package:mime/mime.dart'; 
import '../utils/toon_parser.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8080';

  Future<ReportInsightModel> analyzeReport(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final payload = jsonEncode({
        'mimeType': mimeType,
        'fileBytes': base64String,
      });
      var uri = Uri.parse('$baseUrl/analyze-report');
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> toonData = ToonParser.parse(response.body);
        return ReportInsightModel.fromJson(toonData);
      } else {
        throw Exception('Server Error: ${response.statusCode} \n ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }  
  }
}
