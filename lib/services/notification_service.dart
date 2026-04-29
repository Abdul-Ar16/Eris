import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          debugPrint('Notification clicked: ${notificationResponse.payload}');
        },
      );
      
      // Create the notification channel explicitly for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'eris_main_channel',
        'Eris Notifications',
        description: 'Main channel for Eris app alerts',
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      debugPrint('Notification Service Initialized');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // Use permission_handler for Android 13+ (POST_NOTIFICATIONS)
      final status = await Permission.notification.request();
      debugPrint('Notification permission status: $status');
      
      // Also trigger the plugin-specific request for redundancy
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    try {
      // Ensure we have permission
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        debugPrint('Permission not granted, requesting...');
        status = await Permission.notification.request();
      }

      if (status.isGranted) {
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'eris_main_channel',
          'Eris Notifications',
          channelDescription: 'Main channel for Eris app alerts',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          showWhen: true,
        );
        
        const NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
        );

        await flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: payload,
        );
        debugPrint('Notification shown successfully');
      } else {
        debugPrint('Notification permission denied by user');
      }
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
