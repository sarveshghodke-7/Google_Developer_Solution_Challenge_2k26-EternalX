import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/report_analyzer/data/report_insight_model.dart';
import 'package:mime/mime.dart'; 
import '../utils/toon_parser.dart';
import '../constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {

  Future<Map<String, String>> _getHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

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
        headers: await _getHeaders(),
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

  // REPORTS
  Future<List<dynamic>> fetchReports(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/list/$userId'), 
      headers: await _getHeaders()
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load reports');
  }

  // TRENDS
  Future<String> fetchTrends(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/trends/analyze/$userId'),
      headers: await _getHeaders()
    );
    if (response.statusCode == 200) {
      return response.body; // Returns raw TOON string
    }
    throw Exception('Failed to load trends');
  }

  // MEDICATIONS
  
  Future<List<dynamic>> fetchMedications(String userId) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/meds/list/$userId');
      final response = await http.get(uri, headers: await _getHeaders());

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
        headers: await _getHeaders(),
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
      final response = await http.delete(uri, headers: await _getHeaders());

      if (response.statusCode != 200) {
        throw Exception('Failed to delete medication: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DOCTOR VISITS 
  Future<List<dynamic>> fetchVisits(String userId) async {
    final response = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/visits/list/$userId'), headers: await _getHeaders());
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to load visits');
  }

  Future<void> addVisit(Map<String, dynamic> visitData) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/visits/add'),
      headers: await _getHeaders(),
      body: jsonEncode(visitData),
    );
    if (response.statusCode != 200) throw Exception('Failed to add visit');
  }

  // CAMPAIGNS
  Future<List<dynamic>> fetchCampaigns(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/campaigns/list/$userId'),
      headers: await _getHeaders()
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to load campaigns');
  }

  Future<void> addCampaign(Map<String, dynamic> campaignData) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/campaigns/add'),
      headers: await _getHeaders(),
      body: jsonEncode(campaignData)
    );
    if (response.statusCode != 200) throw Exception('Failed to add campaign');
  }

  Future<void> updateCampaign(String campaignId, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('${AppConstants.apiBaseUrl}/campaigns/update/$campaignId'),
      headers: await _getHeaders(),
      body: jsonEncode(updates)
    );
    if (response.statusCode != 200) throw Exception('Failed to update campaign');
  }
}
