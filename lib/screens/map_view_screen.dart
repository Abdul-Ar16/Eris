import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mock Map Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0D1117), // Deep space blue/black for map
              child: CustomPaint(
                painter: _MapPainter(),
              ),
            ),
          ),

          // Top Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _MapActionButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: ErisColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            children: [
                              Icon(Icons.search_rounded, color: ErisColors.primary),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search for shelters or routes',
                                  style: TextStyle(color: Colors.white38, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(label: 'Shelters', icon: Icons.home_rounded, isSelected: true),
                        _FilterChip(label: 'Safe Zones', icon: Icons.shield_rounded),
                        _FilterChip(label: 'Flooded Roads', icon: Icons.water_drop_rounded),
                        _FilterChip(label: 'Medical', icon: Icons.medical_services_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Controls (Right Side)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                _MapActionButton(icon: Icons.layers_rounded, onPressed: () {}),
                const SizedBox(height: 12),
                _MapActionButton(icon: Icons.my_location_rounded, onPressed: () {}),
                const SizedBox(height: 12),
                _MapActionButton(icon: Icons.zoom_in_rounded, onPressed: () {}),
                _MapActionButton(icon: Icons.zoom_out_rounded, onPressed: () {}),
              ],
            ),
          ),

          // Bottom Info Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ErisColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ErisColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.navigation_rounded, color: ErisColors.success),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fastest Route to Shelter',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '1.2 km • 14 mins via Flower Rd',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ErisColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('START NAVIGATION'),
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

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: ErisColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _FilterChip({required this.label, required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? ErisColors.primary : ErisColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.white54),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Grid lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Main Roads
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.6, size.width * 0.8, size.height);

    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.25);

    canvas.drawPath(path, roadPaint);

    // Hazard Area
    final hazardPaint = Paint()
      ..color = ErisColors.riskHigh.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), 80, hazardPaint);
    
    // Markers
    final markerPaint = Paint()..color = ErisColors.primary;
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.4), 6, markerPaint);
    
    final shelterPaint = Paint()..color = ErisColors.success;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.8), 8, shelterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
