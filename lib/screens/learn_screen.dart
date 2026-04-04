// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            children: [
              Row(
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.arrow_back, color: Colors.white54),
                  // ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'LEARN & PREPARE',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.2),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _LessonCard(
                      header: 'Flood Awareness',
                      headerColor: const Color(0xFF2E5F6A),
                      items: const ['Warning Signs of a Flood', 'What to Do During a Flood', 'How to Prepare for Your Home', 'Emergency Kit Checklist'],
                      icon: Icons.water_drop_outlined,
                    ),
                    const SizedBox(height: 14),
                    _LessonCard(
                      header: 'Landslide Awareness',
                      headerColor: const Color(0xFF6A4C2E),
                      items: const ['Signs of a Coming Landslide', 'Evacuation Procedures', 'Soil & Rain Risk Guide', 'What to Avoid During Instability'],
                      icon: Icons.terrain_outlined,
                    ),
                    const SizedBox(height: 14),
                    _LessonCard(
                      header: 'Emergency Contacts',
                      headerColor: const Color(0xFF2D2A5E),
                      items: const ['Quick access to all hotline numbers'],
                      icon: Icons.phone_callback_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String header;
  final Color headerColor;
  final List<String> items;
  final IconData icon;

  const _LessonCard({
    required this.header,
    required this.headerColor,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white10,
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: headerColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  header,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.white38),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
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

