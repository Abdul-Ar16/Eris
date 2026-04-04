// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EvacuationRouteScreen extends StatelessWidget {
  const EvacuationRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white54),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'EVACUATION ROUTE',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_outlined, color: Colors.white54, size: 44),
                          SizedBox(height: 8),
                          Text('Map preview (placeholder)', style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ShelterCard(
                    title: 'Narahanpita School',
                    subtitle: 'School',
                    capacityText: 'Capacity: 500 people',
                    distanceText: '2.3 km away',
                    actionText: 'Get Directions',
                    accent: const Color(0xFF2F6D3A),
                  ),
                  const SizedBox(height: 12),
                  _ShelterCard(
                    title: 'Community Hall',
                    subtitle: 'Community Hall',
                    capacityText: 'Capacity: 300 people',
                    distanceText: '3.8 km away',
                    actionText: 'Get Directions',
                    accent: const Color(0xFF7D2D2D),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'ROUTE SAFETY',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Road Clear', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F7A40).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF2F7A40)),
                          ),
                          child: const Text('SAFE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelterCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String capacityText;
  final String distanceText;
  final String actionText;
  final Color accent;

  const _ShelterCard({
    required this.title,
    required this.subtitle,
    required this.capacityText,
    required this.distanceText,
    required this.actionText,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withOpacity(0.65)),
                ),
                child: const Text(
                  'AVAILABLE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(capacityText, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 2),
          Text(distanceText, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}

