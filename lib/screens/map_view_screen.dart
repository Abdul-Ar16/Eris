import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1921), // Dark map-like background
      body: Stack(
        children: [
          // Mock Map Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    const Color(0xFF1B3D4F).withOpacity(0.5),
                    const Color(0xFF0A1921),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _MapPainter(),
              ),
            ),
          ),

          // Top UI (Search Bar and Chips)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'MAP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to balance back button
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(24),
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
                        Icon(Icons.location_on, color: Color(0xFF4285F4)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search here',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.white70),
                        SizedBox(width: 12),
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _CategoryChip(icon: Icons.home, label: 'Home'),
                      _CategoryChip(icon: Icons.restaurant, label: 'Restaurants'),
                      _CategoryChip(icon: Icons.local_gas_station, label: 'Gas'),
                      _CategoryChip(icon: Icons.attractions, label: 'Attractions'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map Control Buttons
          Positioned(
            right: 16,
            bottom: 220,
            child: Column(
              children: [
                _MapControlButton(icon: Icons.layers_outlined),
                const SizedBox(height: 12),
                _MapControlButton(icon: Icons.my_location),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF78D1E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.directions, color: Colors.black, size: 28),
                ),
              ],
            ),
          ),

          // Local Vibe Bottom Sheet (Static for UI)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'Local vibe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _BottomNavMock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;

  const _MapControlButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white70, size: 24),
    );
  }
}

class _BottomNavMock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(icon: Icons.location_on, label: 'Explore', isSelected: true),
          _BottomNavItem(icon: Icons.bookmark_border, label: 'You'),
          _BottomNavItem(icon: Icons.add_circle_outline, label: 'Contribute'),
          _BottomNavItem(icon: Icons.business_center_outlined, label: 'Business'),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: isSelected
              ? BoxDecoration(
                  color: const Color(0xFF1E3A3A),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFF78D1E1) : Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw some random lines to simulate roads
    for (var i = 0; i < 15; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 15)),
        Offset(size.width, size.height * (i / 15 + 0.1)),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * (i / 15), 0),
        Offset(size.width * (i / 15 - 0.1), size.height),
        paint,
      );
    }

    // Draw a "Sri Lanka" like shape roughly
    final landPaint = Paint()
      ..color = const Color(0xFF1B3D4F).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.5, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.5, size.width * 0.5, size.height * 0.3);
    canvas.drawPath(path, landPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
