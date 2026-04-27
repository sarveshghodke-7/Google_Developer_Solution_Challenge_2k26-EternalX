
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/report_analyzer/data/report_insight_model.dart';

class LocalStorageService {
  static const String _reportKey = 'latest_report_cache';
  Future<void> saveLatestReport(ReportInsightModel report) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(report.toJson());
    await prefs.setString(_reportKey, jsonString);
    
    print('Report successfully saved to device memory!');
  }

  Future<ReportInsightModel?> getLatestReport() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_reportKey);

    if (jsonString != null) {
      print('Found cached report on device!');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ReportInsightModel.fromJson(jsonMap);
    }
    
    print('No cached report found.');
    return null; 
  }
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reportKey);
  }
}
