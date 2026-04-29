import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/evacuation_service.dart';
import '../theme/app_theme.dart';

class EvacuationRouteScreen extends StatelessWidget {
  const EvacuationRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evacuationService = EvacuationService();
    final userReferencePoint = const LatLng(6.9271, 79.8612);
    final shelters = evacuationService.getNearestShelters(userReferencePoint, limit: 6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EVACUATION ROUTES'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Map Preview
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/map',
              arguments: {'shelterId': shelters.isNotEmpty ? shelters.first.id : null},
            ),
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                color: ErisColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
                image: const DecorationImage(
                  image: AssetImage('assets/map_preview.png'), // Add this to assets if possible, or keep mock
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ErisColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.map_rounded, color: ErisColors.primary, size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tap to Expand Map',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        // backdropFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.gps_fixed_rounded, color: ErisColors.primary, size: 14),
                          SizedBox(width: 6),
                          Text('LIVE TRACKING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Shelters',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, size: 16),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ...shelters.map((shelter) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ShelterCard(
                title: shelter.title,
                type: shelter.type,
                capacity: shelter.capacity,
                distance: shelter.distanceFrom(userReferencePoint),
                time: shelter.time,
                status: shelter.status,
                statusColor:
                    shelter.isSafeRoute ? ErisColors.success : ErisColors.warning,
                onGetDirections: () => Navigator.pushNamed(
                  context,
                  '/map',
                  arguments: {'shelterId': shelter.id},
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ErisColors.riskHigh.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ErisColors.riskHigh.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, color: ErisColors.riskHigh),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Route Advisory',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Baseline Road is currently flooded. Avoid this path.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelterCard extends StatelessWidget {
  final String title;
  final String type;
  final String capacity;
  final String distance;
  final String time;
  final String status;
  final Color statusColor;
  final VoidCallback onGetDirections;

  const _ShelterCard({
    required this.title,
    required this.type,
    required this.capacity,
    required this.distance,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                    Text(distance, style: const TextStyle(color: ErisColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(type, style: const TextStyle(color: Colors.white38, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfo(Icons.people_outline_rounded, capacity),
                    const SizedBox(width: 20),
                    _buildInfo(Icons.directions_walk_rounded, time),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onGetDirections,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: ErisColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: const Center(
                child: Text(
                  'GET DIRECTIONS',
                  style: TextStyle(color: ErisColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
