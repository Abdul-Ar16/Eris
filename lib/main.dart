import 'package:flutter/material.dart';
import 'eris_app.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();
  // Request permissions explicitly on start
  await notificationService.requestPermissions();
  
  runApp(const ErisApp());
}
