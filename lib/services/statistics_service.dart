import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for fetching disaster statistics and disaster reports.
class StatisticsService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DISASTER STATISTICS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<dynamic>> getAllStatistics() async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.statisticsEndpoint}'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getStatsByDistrict(String district) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.statisticsEndpoint}/district/$district'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getStatsByMonthYear(int month, int year) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.statisticsEndpoint}/month/$month/year/$year'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getStatsByDistrictYear(String district, int year) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.statisticsEndpoint}/district/$district/year/$year'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DISASTER REPORTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<dynamic>> getAllReports() async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getReportsByDistrict(String district) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/district/$district'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getReportsByUser(int userId) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/user/$userId'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getReportsByStatus(String status) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/status/$status'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<Map<String, dynamic>?> getReportById(int id) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/$id'),
        headers: await _headers(),
      );
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) { return null; }
  }
}
