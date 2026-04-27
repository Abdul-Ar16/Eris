import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for fetching emergency contacts from the backend.
class EmergencyContactService {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Get all emergency contacts ──────────────────────────────────────────
  Future<List<dynamic>> getAllContacts() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.emergencyContactsEndpoint}');
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

  // ── Get emergency contacts by district ──────────────────────────────────
  Future<List<dynamic>> getContactsByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.emergencyContactsEndpoint}/district/$district');
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

  // ── Get contacts by type (POLICE, HOSPITAL, FIRE, etc.) ─────────────────
  Future<List<dynamic>> getContactsByType(String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.emergencyContactsEndpoint}/type/$type');
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

  // ── Get contacts by district and type ───────────────────────────────────
  Future<List<dynamic>> getContactsByDistrictAndType(
      String district, String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.emergencyContactsEndpoint}/district/$district/type/$type');
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

  // ── Get contact by ID ───────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getContactById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.emergencyContactsEndpoint}/$id');
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
