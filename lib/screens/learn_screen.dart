import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEARN & PREPARE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCategoryCard(
            context,
            title: 'Flood Awareness',
            description: 'Essential survival guides and preparation tips.',
            color: const Color(0xFF006064),
            icon: Icons.water_drop_rounded,
            lessons: [
              'Warning Signs of a Flood',
              'What to Do During a Flood',
              'Emergency Kit Checklist',
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryCard(
            context,
            title: 'Landslide Safety',
            description: 'How to identify risks and evacuate safely.',
            color: const Color(0xFF5D4037),
            icon: Icons.landscape_rounded,
            lessons: [
              'Signs of Earth Instability',
              'Evacuation Procedures',
              'Rainfall Risk Guide',
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryCard(
            context,
            title: 'Emergency Response',
            description: 'Quick reference for immediate crises.',
            color: const Color(0xFF311B92),
            icon: Icons.emergency_rounded,
            lessons: [
              'First Aid Basics',
              'Emergency Contact Directory',
              'Distress Signaling',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required List<String> lessons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: lessons.map((lesson) => _buildLessonItem(lesson)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.play_circle_outline_rounded, size: 20, color: ErisColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white24),
        ],
      ),
    );
  }
}
