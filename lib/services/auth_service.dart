import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthService {
  // ── Helper: get saved JWT token ──────────────────────────────────────────
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // ── Helper: get saved user ID ────────────────────────────────────────────
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // ── Helper: get saved user district ──────────────────────────────────────
  Future<String?> getUserDistrict() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_district');
  }

  // ── Helper: get auth headers ─────────────────────────────────────────────
  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Register User ───────────────────────────────────────────────────────
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

  // ── Login User ──────────────────────────────────────────────────────────
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

      final result = await _handleResponse(response);

      // Save user data locally on successful login
      if (result['success'] && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        if (data['id'] != null) {
          await prefs.setInt('user_id', data['id']);
        }
        if (data['fullName'] != null) {
          await prefs.setString('user_name', data['fullName']);
        }
        if (data['email'] != null) {
          await prefs.setString('user_email', data['email']);
        }
        if (data['district'] != null) {
          await prefs.setString('user_district', data['district']);
        }
        if (data['phoneNumber'] != null) {
          await prefs.setString('user_phone', data['phoneNumber']);
        }
        if (data['role'] != null) {
          await prefs.setString('user_role', data['role'].toString());
        }
      }

      return result;
    } catch (e) {
      return {'success': false, 'message': 'Network error. Make sure your Spring Boot server is running.'};
    }
  }

  // ── Get Profile ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profileEndpoint}');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load profile.'};
    }
  }

  // ── Update Profile ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNumber,
    required String district,
    String preferredLanguage = 'EN',
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profileEndpoint}');
      final headers = await _authHeaders();
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'district': district,
          'preferredLanguage': preferredLanguage,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to update profile.'};
    }
  }

  // ── Change Password ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changePasswordEndpoint}');
      final headers = await _authHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to change password.'};
    }
  }

  // ── Forgot Password ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.forgotPasswordEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to send reset request.'};
    }
  }

  // ── Reset Password ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetPasswordEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'resetToken': resetToken,
          'newPassword': newPassword,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Failed to reset password.'};
    }
  }

  // ── Send SOS Report ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendSosReport({
    required double latitude,
    required double longitude,
    required String district,
    String? description,
  }) async {
    try {
      final userId = await getUserId() ?? 1;
      final url = Uri.parse('${ApiConstants.baseUrl}/reports/user/$userId');
      final headers = await _authHeaders();

      final response = await http.post(
        url,
        headers: headers,
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

  // ── Helper to process response and save token ───────────────────────────
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
        if (errorData is Map) {
          return {'success': false, 'message': errorData['message'] ?? response.body};
        }
        return {'success': false, 'message': response.body};
      } catch (_) {
        // Fallback for raw string errors (e.g. "Email already registered!")
        return {'success': false, 'message': response.body};
      }
    }
  }

  // ── Helper to log out ───────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_district');
    await prefs.remove('user_phone');
    await prefs.remove('user_role');
  }
}
