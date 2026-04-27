import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for fetching real-time sensor readings and weather data
/// for the Monitor screen.
class MonitorService {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Get latest sensor readings by station ───────────────────────────────
  Future<List<dynamic>> getLatestReadings(int stationId) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.sensorsEndpoint}/station/$stationId/latest');
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

  // ── Get all readings by station ─────────────────────────────────────────
  Future<List<dynamic>> getReadingsByStation(int stationId) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.sensorsEndpoint}/station/$stationId');
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

  // ── Get readings by risk level (SAFE, CAUTION, WARNING, DANGER) ─────────
  Future<List<dynamic>> getReadingsByRiskLevel(String riskLevel) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.sensorsEndpoint}/risk/$riskLevel');
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

  // ── Get all monitoring stations ─────────────────────────────────────────
  Future<List<dynamic>> getAllStations() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.stationsEndpoint}');
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

  // ── Get monitoring stations by district ─────────────────────────────────
  Future<List<dynamic>> getStationsByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.stationsEndpoint}/district/$district');
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

  // ── Get monitoring stations by type (FLOOD / LANDSLIDE) ─────────────────
  Future<List<dynamic>> getStationsByType(String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.stationsEndpoint}/type/$type');
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

  // ── Get latest weather data for district ────────────────────────────────
  Future<Map<String, dynamic>?> getLatestWeather(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}/district/$district/latest');
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

  // ── Get all weather data by district ────────────────────────────────────
  Future<List<dynamic>> getWeatherByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}/district/$district');
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

  // ── Get weather data by risk level ──────────────────────────────────────
  Future<List<dynamic>> getWeatherByRisk(String risk) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}/risk/$risk');
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
