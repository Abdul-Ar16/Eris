import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmergencySosScreen extends StatelessWidget {
  const EmergencySosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMERGENCY SOS'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Emergency Assistance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your precise location will be shared with emergency services and your primary contacts immediately.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Animated SOS Button Container
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ripple Effect (Static for now, but implies animation)
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ErisColors.danger.withOpacity(0.05),
                  ),
                ),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ErisColors.danger.withOpacity(0.1),
                  ),
                ),
                // Main Button
                GestureDetector(
                  onTap: () {
                    // SOS Logic
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ErisColors.danger,
                      boxShadow: [
                        BoxShadow(
                          color: ErisColors.danger.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Press and hold for 3 seconds',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const Spacer(),
            // Emergency Contacts Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ErisColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.contact_phone_rounded, color: ErisColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Quick Dial',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildEmergencyContact('Police', '119', Icons.local_police_rounded),
                  const Divider(height: 24, color: Colors.white10),
                  _buildEmergencyContact('Ambulance', '110', Icons.medical_services_rounded),
                  const Divider(height: 24, color: Colors.white10),
                  _buildEmergencyContact('Fire Brigade', '110', Icons.fire_truck_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(String label, String number, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              Text(number, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call_rounded, color: Colors.greenAccent),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
