import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/alerts_flow_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/learn_screen.dart';
import '../screens/monitor_screen.dart';
import '../screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _tabs = const <Widget>[
    HomeScreen(),
    HistoryScreen(),
    AlertsFlowScreen(),
    MonitorScreen(),
    LearnScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ErisColors.background,
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: ErisColors.background,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ErisColors.primary,
          unselectedItemColor: Colors.white38,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _index,
          onTap: (value) => setState(() => _index = value),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined),
              activeIcon: Icon(Icons.notifications_active_rounded),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics_rounded),
              label: 'Monitor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school_rounded),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
