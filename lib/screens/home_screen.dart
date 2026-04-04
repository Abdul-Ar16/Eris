// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const location = 'Colombo, Western Province';
    return Scaffold(
      backgroundColor: ErisColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // IconButton(
                  //   onPressed: null,
                  //   icon: const Icon(Icons.arrow_back, color: Colors.white54),
                  // ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'HOME',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.white60),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Location',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    location,
                    style: const TextStyle(
                      color: ErisColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _RiskCard(
                title: 'Flood Risk',
                level: 'HIGH',
                color: ErisColors.floodHigh,
              ),
              const SizedBox(height: 18),
              _RiskCard(
                title: 'Landslide Risk',
                level: 'MEDIUM',
                color: ErisColors.riskMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/evacuation'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueGrey, width: 1.2),
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: const Text(
                    'View Evacuation Route',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/sos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.danger.withOpacity(0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: const Text(
                    'SOS EMERGENCY',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.2),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final String title;
  final String level;
  final Color color;

  const _RiskCard({
    required this.title,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.65),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              level,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

