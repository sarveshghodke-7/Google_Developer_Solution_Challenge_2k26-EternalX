import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/report_analyzer/data/report_insight_model.dart';
import 'package:mime/mime.dart'; 
import '../utils/toon_parser.dart';
import '../constants/app_constants.dart';

class ApiService {

  Future<ReportInsightModel> analyzeReport(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      
      final payload = jsonEncode({
        'mimeType': mimeType,
        'fileBytes': base64String,
      });
      
      var uri = Uri.parse('${AppConstants.apiBaseUrl}/analyze-report');
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

  // MEDICATIONS
  
  Future<List<dynamic>> fetchMedications(String userId) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/meds/list/$userId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load medications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  Future<void> addMedication(Map<String, dynamic> medicationData) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/meds/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(medicationData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add medication: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  Future<void> deleteMedication(String userId, String medId) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/meds/remove/$userId/$medId');
      final response = await http.delete(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete medication: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
