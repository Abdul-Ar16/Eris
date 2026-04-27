import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for fetching evacuation routes and safe zones from the backend.
class EvacuationService {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EVACUATION ROUTES
  // ═══════════════════════════════════════════════════════════════════════

  // ── Get all evacuation routes ───────────────────────────────────────────
  Future<List<dynamic>> getAllRoutes() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}');
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

  // ── Get evacuation routes by district ───────────────────────────────────
  Future<List<dynamic>> getRoutesByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/district/$district');
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

  // ── Get routes by district and disaster type ────────────────────────────
  Future<List<dynamic>> getRoutesByDistrictAndType(
      String district, String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/district/$district/type/$type');
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

  // ── Get route by ID ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getRouteById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/$id');
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

  // ═══════════════════════════════════════════════════════════════════════
  //  SAFE ZONES
  // ═══════════════════════════════════════════════════════════════════════

  // ── Get all safe zones ──────────────────────────────────────────────────
  Future<List<dynamic>> getAllSafeZones() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}');
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

  // ── Get safe zones by district ──────────────────────────────────────────
  Future<List<dynamic>> getSafeZonesByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/district/$district');
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

  // ── Get safe zones by type ──────────────────────────────────────────────
  Future<List<dynamic>> getSafeZonesByType(String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/type/$type');
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

  // ── Get safe zone by ID ─────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getSafeZoneById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/$id');
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
}
