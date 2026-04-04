import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ErisColors.primary, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: ErisColors.surface,
                          child: Text(
                            'V',
                            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: ErisColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vihangi Ranasinghe',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Colombo, Western Province',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSectionHeader('ALERT PREFERENCES'),
            _buildSettingsGroup([
              _buildSwitchTile('Flood Alerts', Icons.water_drop_outlined, _floodAlerts, (v) => setState(() => _floodAlerts = v)),
              _buildSwitchTile('Landslide Alerts', Icons.landscape_outlined, _landslideAlerts, (v) => setState(() => _landslideAlerts = v)),
              _buildSwitchTile('Push Notifications', Icons.notifications_none_rounded, _pushNotifications, (v) => setState(() => _pushNotifications = v)),
            ]),
            
            const SizedBox(height: 24),
            _buildSectionHeader('LOCATION SETTINGS'),
            _buildSettingsGroup([
              _buildSwitchTile('Real-time Tracking', Icons.location_on_outlined, _useLocation, (v) => setState(() => _useLocation = v)),
              const ListTile(
                leading: Icon(Icons.map_outlined, color: Colors.white38),
                title: Text('Primary Residence', style: TextStyle(color: Colors.white, fontSize: 15)),
                subtitle: Text('Colombo 05, Western Province', style: TextStyle(color: Colors.white38, fontSize: 12)),
                trailing: Icon(Icons.chevron_right_rounded, color: Colors.white24),
              ),
            ]),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                icon: const Icon(Icons.logout_rounded, size: 20, color: ErisColors.danger),
                label: const Text('LOG OUT', style: TextStyle(color: ErisColors.danger)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white10),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: ErisColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(String label, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.white70, size: 22),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
      value: value,
      onChanged: onChanged,
      activeColor: ErisColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
