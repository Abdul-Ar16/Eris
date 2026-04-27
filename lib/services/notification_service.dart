import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

/// Service for managing user notifications and user-alerts.
class NotificationService {
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

  Future<List<dynamic>> getUserNotifications() async {
    try {
      final uid = await _userId();
      if (uid == null) return [];
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsEndpoint}/user/$uid'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getUnreadNotifications() async {
    try {
      final uid = await _userId();
      if (uid == null) return [];
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsEndpoint}/user/$uid/unread'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<int> countUnread() async {
    try {
      final uid = await _userId();
      if (uid == null) return 0;
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsEndpoint}/user/$uid/unread/count'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? (int.tryParse(r.body) ?? 0) : 0;
    } catch (_) { return 0; }
  }

  Future<bool> markAsRead(int id) async {
    try {
      final r = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsEndpoint}/$id/read'),
        headers: await _headers(),
      );
      return r.statusCode == 200;
    } catch (_) { return false; }
  }

  Future<bool> deleteNotification(int id) async {
    try {
      final r = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationsEndpoint}/$id'),
        headers: await _headers(),
      );
      return r.statusCode == 200;
    } catch (_) { return false; }
  }

  // ── User Alerts ─────────────────────────────────────────────────────────
  Future<List<dynamic>> getUserAlerts() async {
    try {
      final uid = await _userId();
      if (uid == null) return [];
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userAlertsEndpoint}/user/$uid'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<List<dynamic>> getUnreadUserAlerts() async {
    try {
      final uid = await _userId();
      if (uid == null) return [];
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userAlertsEndpoint}/user/$uid/unread'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? jsonDecode(r.body) as List : [];
    } catch (_) { return []; }
  }

  Future<int> countUnreadAlerts() async {
    try {
      final uid = await _userId();
      if (uid == null) return 0;
      final r = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userAlertsEndpoint}/user/$uid/unread/count'),
        headers: await _headers(),
      );
      return r.statusCode == 200 ? (int.tryParse(r.body) ?? 0) : 0;
    } catch (_) { return 0; }
  }

  Future<bool> markAlertRead(int userAlertId) async {
    try {
      final r = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userAlertsEndpoint}/$userAlertId/read'),
        headers: await _headers(),
      );
      return r.statusCode == 200;
    } catch (_) { return false; }
  }
}
