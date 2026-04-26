import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthService {
  // Register User
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String district,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'district': district,
          'role': 'USER',
          'isActive': true,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error. Make sure your Spring Boot server is running.'};
    }
  }

  // Send SOS Report
  Future<Map<String, dynamic>> sendSosReport({
    required double latitude,
    required double longitude,
    required String district,
    String? description,
  }) async {
    try {
      // For now, using a default userId of 1 since we are in testing. 
      // In production, this would come from the saved JWT/User profile.
      const int userId = 1;
      final url = Uri.parse('${ApiConstants.baseUrl}/reports/user/$userId');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'SOS EMERGENCY ALERT',
          'description': description ?? 'Emergency assistance requested via SOS button.',
          'district': district,
          'latitude': latitude,
          'longitude': longitude,
          'type': 'OTHER',
          'status': 'PENDING'
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to send SOS. Check connection.'};
    }
  }

  // Login User
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error. Make sure your Spring Boot server is running.'};
    }
  }

  // Helper to process response and save token
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        // Fallback if backend returns plain text instead of JSON on success
      }
      
      // If the backend returns a token, save it securely
      if (data.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
      }
      return {'success': true, 'data': data, 'message': response.body};
    } else {
      // Trying to parse JSON error message if possible
      try {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? response.body};
      } catch (_) {
        // Fallback for raw string errors (e.g. "Email already registered!")
        return {'success': false, 'message': response.body};
      }
    }
  }

  // Helper to log out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
