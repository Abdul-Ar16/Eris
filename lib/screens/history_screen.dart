import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4D3A),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: const Text(
          'DISASTER HISTORY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isHighAlert = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isHighAlert ? const Color(0xFF7A2D2D) : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'High Alert',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isHighAlert = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isHighAlert ? const Color(0xFFB06A2E) : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Medium Alert',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of Alerts
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: isHighAlert ? _buildHighAlerts() : _buildMediumAlerts(),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 80,
      //   color: const Color(0xFF4A4D3A),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       _buildNavItem('Home', Icons.home_outlined),
      //       _buildNavItem('Alerts', Icons.notifications, isActive: true),
      //       _buildNavItem('Monitor', Icons.bar_chart),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? Colors.yellow : Colors.white70, size: 28),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildHighAlerts() {
    return [
      _AlertCard(
        type: 'Flood',
        icon: '🌊',
        date: '14 Mar 2026 . 02:15',
        location: 'Kelani River Basin, Colombo',
        severity: 'HIGH ALERT',
        severityColor: const Color(0xFF7A2D2D),
      ),
      _AlertCard(
        type: 'Landslide',
        icon: '⛰️',
        date: '02 Mar 2026 . 18:40',
        location: 'Kandy - Peradeniya Road',
        severity: 'HIGH ALERT',
        severityColor: const Color(0xFF7A2D2D),
      ),
      _AlertCard(
        type: 'Flood',
        icon: '🌊',
        date: '21 Feb 2026 . 09:30',
        location: 'Gampaha District',
        severity: 'HIGH ALERT',
        severityColor: const Color(0xFF7A2D2D),
      ),
    ];
  }

  List<Widget> _buildMediumAlerts() {
    return [
      _AlertCard(
        type: 'Flood',
        icon: '🌊',
        date: '15 Mar 2026 . 11:20',
        location: 'Ratnapura - Kalu River',
        severity: 'MEDIUM ALERT',
        severityColor: const Color(0xFFB06A2E),
      ),
      _AlertCard(
        type: 'Landslide',
        icon: '⛰️',
        date: '10 Mar 2026 . 07:45',
        location: 'Nuwara Eliya District',
        severity: 'MEDIUM ALERT',
        severityColor: const Color(0xFFB06A2E),
      ),
      _AlertCard(
        type: 'Flood',
        icon: '🌊',
        date: '27 Feb 2026 . 16:00',
        location: 'Matara - Southern Coast',
        severity: 'MEDIUM ALERT',
        severityColor: const Color(0xFFB06A2E),
      ),
    ];
  }
}

class _AlertCard extends StatelessWidget {
  final String type;
  final String icon;
  final String date;
  final String location;
  final String severity;
  final Color severityColor;

  const _AlertCard({
    required this.type,
    required this.icon,
    required this.date,
    required this.location,
    required this.severity,
    required this.severityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: severityColor.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Text(
                          severity,
                          style: TextStyle(
                            color: severityColor.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
