class ApiConstants {
  // Use 10.0.2.2 for Android Emulators to reach the computer's localhost
  // static const String baseUrl = 'http://10.0.2.2:8080/api';

  // If using a physical device, change this to the computer's local IP address (e.g., http://192.168.1.5:8080/api)
  static const String baseUrl = 'https://eris-backend-bepl.onrender.com/api';


  // ── Auth ─────────────────────────────────────────────────
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/auth/profile';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String usersEndpoint = '/auth/users';

  // ── Alerts ───────────────────────────────────────────────
  static const String alertsEndpoint = '/alerts';

  // ── Disaster Reports ─────────────────────────────────────
  static const String reportsEndpoint = '/reports';

  // ── Disaster Statistics ──────────────────────────────────
  static const String statisticsEndpoint = '/statistics';

  // ── Emergency Contacts ───────────────────────────────────
  static const String emergencyContactsEndpoint = '/emergency-contacts';

  // ── Evacuation Routes ────────────────────────────────────
  static const String evacuationRoutesEndpoint = '/evacuation-routes';

  // ── Monitoring Stations ──────────────────────────────────
  static const String stationsEndpoint = '/stations';

  // ── Notifications ────────────────────────────────────────
  static const String notificationsEndpoint = '/notifications';

  // ── Safe Zones ───────────────────────────────────────────
  static const String safeZonesEndpoint = '/safe-zones';

  // ── Sensor Readings ──────────────────────────────────────
  static const String sensorsEndpoint = '/sensors';

  // ── System Logs ──────────────────────────────────────────
  static const String logsEndpoint = '/logs';

  // ── User Alerts ──────────────────────────────────────────
  static const String userAlertsEndpoint = '/user-alerts';

  // ── User Locations ───────────────────────────────────────
  static const String locationsEndpoint = '/locations';

  // ── Weather Data ─────────────────────────────────────────
  static const String weatherEndpoint = '/weather';

  // ── ML Predictions (Random Forest) ───────────────────────
  static const String mlPredictionEndpoint = '/ml/prediction';
  static const String mlPredictionLatestEndpoint = '/ml/prediction/latest';
  static const String mlPredictionHistoryEndpoint = '/ml/prediction/history';
}
