import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for fetching and managing disaster alerts from the backend.
class AlertService {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Get all active alerts ───────────────────────────────────────────────
  Future<List<dynamic>> getActiveAlerts() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}/active');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get alerts by district ──────────────────────────────────────────────
  Future<List<dynamic>> getAlertsByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}/district/$district');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get active alerts by district ───────────────────────────────────────
  Future<List<dynamic>> getActiveAlertsByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}/district/$district/active');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get alert by ID ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getAlertById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}/$id');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Get alerts by type (FLOOD / LANDSLIDE) ──────────────────────────────
  Future<List<dynamic>> getAlertsByType(String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}/type/$type');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
