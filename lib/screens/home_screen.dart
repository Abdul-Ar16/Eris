import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const location = 'Colombo, Western Province';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 80,
            backgroundColor: ErisColors.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                'DASHBOARD',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLocationCard(location),
                const SizedBox(height: 24),
                Text(
                  'Current Risks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const _RiskCard(
                  title: 'Flood Risk',
                  level: 'HIGH',
                  color: ErisColors.riskHigh,
                  icon: Icons.water_drop_rounded,
                ),
                const SizedBox(height: 16),
                const _RiskCard(
                  title: 'Landslide Risk',
                  level: 'MEDIUM',
                  color: ErisColors.riskMedium,
                  icon: Icons.landscape_rounded,
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/evacuation'),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('View Evacuation Route'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/sos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.danger,
                    shadowColor: ErisColors.danger.withOpacity(0.4),
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('SOS EMERGENCY'),
                ),
                const SizedBox(height: 16),
                // Test Notification Button
                ElevatedButton.icon(
                  onPressed: () async {
                    await NotificationService().showNotification(
                      title: 'Evacuation Warning',
                      body: 'Your area is under danger and evacuation is needed.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.primary,
                  ),
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('TEST NOTIFICATION'),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String location) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ErisColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: ErisColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final String title;
  final String level;
  final Color color;
  final IconData icon;

  const _RiskCard({
    required this.title,
    required this.level,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}
