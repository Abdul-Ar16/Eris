import 'package:flutter/material.dart';

import 'screens/history_screen.dart';
import 'screens/evacuation_route_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/login_screen.dart';
import 'screens/monitor_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/emergency_sos_screen.dart';
import 'screens/map_view_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_shell.dart';

class ErisApp extends StatelessWidget {
  const ErisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ErisTheme.build(),
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainShell(),
        '/home': (_) => const HomeScreen(),
        '/history': (_) => const HistoryScreen(),
        '/monitor': (_) => const MonitorScreen(),
        '/learn': (_) => const LearnScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/evacuation': (_) => const EvacuationRouteScreen(),
        '/sos': (_) => const EmergencySosScreen(),
        '/map': (_) => const MapViewScreen(),
      },
      initialRoute: '/',
    );
  }
}
