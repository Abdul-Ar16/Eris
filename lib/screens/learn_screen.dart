import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      appBar: AppBar(
        title: const Text('LEARN & PREPARE'),
        backgroundColor: ErisColors.background,
        elevation: 0,
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
              color: color.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.3),
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
            padding: const EdgeInsets.all(8),
            child: Column(
              children: lessons.map((lesson) => _buildLessonItem(context, lesson)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(BuildContext context, String title) {
    return InkWell(
      onTap: () => _showLessonDetail(context, title),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
             Icon(Icons.play_circle_outline_rounded, size: 22, color: ErisColors.primaryLight),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: ErisColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  void _showLessonDetail(BuildContext context, String title) {
    String detailText = '';
    IconData detailIcon = Icons.info_outline_rounded;
    Color detailColor = ErisColors.primary;

    switch (title) {
      // Flood Awareness
      case 'Warning Signs of a Flood':
        detailIcon = Icons.warning_amber_rounded;
        detailColor = Colors.blueGrey;
        detailText = '• Continuous or heavy rainfall over several hours or days.\n'
                     '• Water levels in rivers or streams rising rapidly.\n'
                     '• Water ponding in low-lying areas or yards.\n'
                     '• Unusual debris or muddy water in streams.\n'
                     '• Listen to local weather updates and flood warnings.';
        break;
      case 'What to Do During a Flood':
        detailIcon = Icons.directions_run_rounded;
        detailColor = Colors.blueAccent;
        detailText = '• Move to higher ground immediately.\n'
                     '• Do not walk, swim, or drive through floodwaters. Just 6 inches of moving water can knock you down.\n'
                     '• Evacuate if instructed to do so by authorities.\n'
                     '• Turn off utilities (gas, electricity, water) at the main switches/valves if time permits.';
        break;
      case 'Emergency Kit Checklist':
        detailIcon = Icons.backpack_rounded;
        detailColor = ErisColors.primary;
        detailText = '• Water (one gallon per person per day for at least 3 days).\n'
                     '• Non-perishable food (at least a 3-day supply).\n'
                     '• Battery-powered or hand-crank radio.\n'
                     '• Flashlight and extra batteries.\n'
                     '• First aid kit and necessary medications.\n'
                     '• Power banks for mobile devices.';
        break;

      // Landslide Safety
      case 'Signs of Earth Instability':
        detailIcon = Icons.terrain_rounded;
        detailColor = Colors.brown;
        detailText = '• New cracks or bulges appearing in the ground, roads, or pavements.\n'
                     '• Trees, retaining walls, or utility poles seemingly leaning.\n'
                     '• Sudden changes in water flow in streams or springs (suddenly muddy or suddenly drying up).\n'
                     '• Unexplained ground surface settling or subsidences.';
        break;
      case 'Evacuation Procedures':
        detailIcon = Icons.exit_to_app_rounded;
        detailColor = Colors.brown.shade400;
        detailText = '• Stay awake and alert during severe storms.\n'
                     '• Listen for unusual sounds indicating moving debris (e.g., trees cracking, boulders knocking).\n'
                     '• If you suspect imminent danger, evacuate immediately. Do not wait for an official warning.\n'
                     '• Move quickly out of the path of the landslide or debris flow towards elevated ground.';
        break;
      case 'Rainfall Risk Guide':
        detailIcon = Icons.thunderstorm_rounded;
        detailColor = Colors.blueGrey;
        detailText = '• Extended periods of heavy rain greatly increase landslide risks on steep slopes.\n'
                     '• Be extra vigilant when rainfall exceeds typical monthly averages in a few days.\n'
                     '• Monitor local weather stations for extreme rainfall alerts.\n'
                     '• Areas with recent wildfires or deforestation are particularly vulnerable to rainfall-induced landslides.';
        break;

      // Emergency Response
      case 'First Aid Basics':
        detailIcon = Icons.medical_services_rounded;
        detailColor = Colors.redAccent;
        detailText = '• Bleeding: Apply firm, direct pressure with a clean cloth until bleeding stops.\n'
                     '• Burns: Cool the burn under cool running water for at least 10 minutes.\n'
                     '• CPR: If unconscious and not breathing normally, push hard and fast in the center of the chest (100-120 pushes a minute).\n'
                     '• Always ensure the scene is safe before offering assistance, and call emergency services immediately.';
        break;
      case 'Emergency Contact Directory':
        detailIcon = Icons.contact_phone_rounded;
        detailColor = Colors.deepPurple;
        detailText = '• Keep a physical list of essential numbers: Ambulance (1990), Police (119), Fire Rescue (110).\n'
                     '• Save important contacts as "ICE" (In Case of Emergency) in your phone.\n'
                     '• Establish an out-of-state or out-of-town contact for all family members to check in with during large-scale disasters.';
        break;
      case 'Distress Signaling':
        detailIcon = Icons.sos_rounded;
        detailColor = Colors.orangeAccent;
        detailText = '• Whistle: Three short blasts is the international distress signal for help.\n'
                     '• Visual: Use a flashlight in the dark (flash three times quickly, three times slowly, three times quickly to signal S.O.S).\n'
                     '• Clothing: Hang or wave brightly colored clothing if stranded outdoors.\n'
                     '• Mirrors/Glass: Reflect sunlight towards search and rescue teams (helicopters or boats).';
        break;
      default:
        detailText = 'Detailed information is not available for this topic yet.';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: ErisColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: detailColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(detailIcon, color: detailColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: ErisColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                detailText,
                style: const TextStyle(
                  color: ErisColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.surfaceVariant,
                    foregroundColor: ErisColors.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
