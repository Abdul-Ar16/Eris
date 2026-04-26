class ApiConstants {
  // Use 10.0.2.2 for Android Emulators to reach the computer's localhost
  // If using a physical device, change this to the computer's local IP address (e.g., http://192.168.1.5:8080/api)
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
}
