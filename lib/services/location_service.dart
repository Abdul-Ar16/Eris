import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for updating and fetching user location.
class LocationService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<int?> _userId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  /// Update current user's location on the backend.
  Future<Map<String, dynamic>?> updateLocation({
    required double latitude,
    required double longitude,
    required String district,
  }) async {
    try {
      final uid = await _userId();
      if (uid == null) return null;

      final r = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.locationsEndpoint}/user/$uid'),
        headers: await _headers(),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'district': district,
        }),
      );
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get current user's saved location.
  Future<Map<String, dynamic>?> getUserLocation() async {
    try {
      final uid = await _userId();
      if (uid == null) return null;

      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.locationsEndpoint}/user/$uid'),
        headers: await _headers(),
      );
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get all users in a district (for district-wide alerts).
  Future<List<dynamic>> getUsersByDistrict(String district) async {
    try {
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.locationsEndpoint}/district/$district'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) {
      return [];
    }
  }
}
