import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _floodAlerts = true;
  bool _landslideAlerts = true;
  bool _pushNotifications = true;
  bool _smsAlerts = false;
  bool _useLocation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
            color: const Color(0xFF4A4D3A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(
                //   onPressed: () => Navigator.of(context).pop(),
                //   icon: const Icon(Icons.arrow_back, color: Colors.white70),
                //   padding: EdgeInsets.zero,
                //   constraints: const BoxConstraints(),
                // ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFF0B062C),
                      child: Text(
                        'V',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vihangi',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.red, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Colombo 05, Western Province',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                _buildSectionHeader('ALERT PREFERENCES'),
                _buildCard([
                  _buildSwitchRow('🌊 Flood Alerts', _floodAlerts, (v) => setState(() => _floodAlerts = v)),
                  _buildDivider(),
                  _buildSwitchRow('⛰️ Landslide Alerts', _landslideAlerts, (v) => setState(() => _landslideAlerts = v)),
                  _buildDivider(),
                  _buildSwitchRow('🔔 Push Notifications', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
                  _buildDivider(),
                  _buildSwitchRow('📱 SMS Alerts', _smsAlerts, (v) => setState(() => _smsAlerts = v)),
                ]),
                const SizedBox(height: 25),
                _buildSectionHeader('LOCATION'),
                _buildCard([
                  _buildSwitchRow('📍 Use My Location', _useLocation, (v) => setState(() => _useLocation = v)),
                  _buildDivider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Colombo 05, Western Province',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionHeader('ACCOUNT'),
                _buildCard([
                  _buildInfoRow(Icons.phone_outlined, '+94 77 123 4567'),
                  _buildDivider(),
                  _buildInfoRow(Icons.email_outlined, '[email protected]', isLink: true),
                ]),
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: 180,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF7A2D2D), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(color: Color(0xFFC43B3B), fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white24, height: 1, indent: 16, endIndent: 16);
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFB06A2E),
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? Colors.blueAccent : Colors.white, size: 26),
        Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
