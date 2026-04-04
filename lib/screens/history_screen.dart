import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isHighAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DISASTER HISTORY'),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildFilterTab('High Alert', true, ErisColors.riskHigh),
                const SizedBox(width: 12),
                _buildFilterTab('Medium Alert', false, ErisColors.riskMedium),
              ],
            ),
          ),
          // List of Alerts
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: isHighAlert ? _buildHighAlerts() : _buildMediumAlerts(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool active, Color color) {
    final bool isSelected = isHighAlert == active;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isHighAlert = active),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : ErisColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.white10,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHighAlerts() {
    return [
      const _AlertCard(
        type: 'Flood',
        icon: Icons.water_drop_rounded,
        date: '14 Mar 2026',
        time: '02:15 AM',
        location: 'Kelani River Basin, Colombo',
        severity: 'HIGH ALERT',
        color: ErisColors.riskHigh,
      ),
      const _AlertCard(
        type: 'Landslide',
        icon: Icons.landscape_rounded,
        date: '02 Mar 2026',
        time: '06:40 PM',
        location: 'Kandy - Peradeniya Road',
        severity: 'HIGH ALERT',
        color: ErisColors.riskHigh,
      ),
    ];
  }

  List<Widget> _buildMediumAlerts() {
    return [
      const _AlertCard(
        type: 'Flood',
        icon: Icons.water_drop_rounded,
        date: '15 Mar 2026',
        time: '11:20 AM',
        location: 'Ratnapura - Kalu River',
        severity: 'MEDIUM ALERT',
        color: ErisColors.riskMedium,
      ),
    ];
  }
}

class _AlertCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final String date;
  final String time;
  final String location;
  final String severity;
  final Color color;

  const _AlertCard({
    required this.type,
    required this.icon,
    required this.date,
    required this.time,
    required this.location,
    required this.severity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(date, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                severity,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
