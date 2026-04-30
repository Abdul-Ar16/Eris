import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  final AuthService _authService = AuthService();
  bool _isSending = false;

  Future<void> _triggerSos() async {
    setState(() => _isSending = true);

    try {
      // 1. Get Location Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackbar('Location permissions are permanently denied.', Colors.red);
        setState(() => _isSending = false);
        return;
      }

      // 2. Get Current Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      // 3. Send to Backend
      final result = await _authService.sendSosReport(
        latitude: position.latitude,
        longitude: position.longitude,
        district: 'Colombo', // In production, reverse geocode this
      );

      if (mounted) {
        if (result['success']) {
          _showSnackbar('SOS ALERT SENT SUCCESSFULLY!', Colors.green);
        } else {
          _showSnackbar(result['message'] ?? 'Failed to send SOS', Colors.red);
        }
      }
    } catch (e) {
      _showSnackbar('Error triggering SOS: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Using Uri.parse directly is often more reliable for short codes 
    // to prevent the OS from misinterpreting the URI structure.
    final Uri launchUri = Uri.parse('tel:${phoneNumber.trim()}');
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showSnackbar('Could not launch dialer for $phoneNumber', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Error launching dialer: $e', Colors.red);
    }
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
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
                          GestureDetector(
                            onTap: _isSending ? null : _triggerSos,
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
                              child: Center(
                                child: _isSending
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
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
                        'Press the button to send immediate alert',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                      const Spacer(),
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
                            _buildEmergencyContact('Ambulance / Fire & rescue', '110', Icons.medical_services_rounded),
                            const Divider(height: 24, color: Colors.white10),
                            _buildEmergencyContact('Disaster Management Center', '0764523123', Icons.warning_amber_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
          onPressed: () => _makePhoneCall(number),
          icon: const Icon(Icons.call_rounded, color: Colors.greenAccent),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
