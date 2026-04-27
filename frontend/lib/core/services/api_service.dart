import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';

/// Central HTTP client for all MediCore backend API calls.
///
/// Automatically attaches the Firebase ID token to every request.
/// All methods throw [ApiException] on failure.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── Auth Header ─────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final user = _auth.currentUser;
    if (user == null) throw ApiException('User is not logged in.', 401);

    final token = await user.getIdToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // ─── Analyze Report ──────────────────────────────────────────────────────

  /// Uploads a medical report file and returns the AI analysis.
  ///
  /// Returns a [Map] matching the [ReportInsightModel] JSON contract.
  Future<Map<String, dynamic>> analyzeReport(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw ApiException('User is not logged in.', 401);
    final token = await user.getIdToken();

    final uri = Uri.parse('${AppConstants.apiBaseUrl}/analyze-report');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () => throw ApiException(
        'Analysis timed out. Please try a smaller file or try again.',
        408,
      ),
    );

    final response = await http.Response.fromStream(streamedResponse);
    return _handleJsonResponse(response);
  }

  // ─── Reports ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getReports() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/reports');
    final response = await http.get(uri, headers: headers);
    return _handleJsonResponse(response);
  }

  // ─── Timeline ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getTimeline() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/timeline');
    final response = await http.get(uri, headers: headers);
    return _handleJsonResponse(response);
  }

  // ─── Campaigns ───────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getCampaigns() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/campaigns');
    final response = await http.get(uri, headers: headers);
    return _handleJsonResponse(response);
  }

  Future<void> joinCampaign(String campaignId) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/campaigns/$campaignId/join');
    final response = await http.post(uri, headers: headers);
    _handleJsonResponse(response);
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  Map<String, dynamic> _handleJsonResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    String message;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = body['error']?.toString() ?? 'Unknown error.';
    } catch (_) {
      message = response.body.isNotEmpty ? response.body : 'Unknown error.';
    }

    throw ApiException(message, response.statusCode);
  }
}

/// Thrown when an API call fails.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
