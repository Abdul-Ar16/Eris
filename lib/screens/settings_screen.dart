import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';

/// Settings hub: account summary, notifications, location, emergency contacts, system.
/// Open [ProfileScreen] via **Edit Profile** for full profile view.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _criticalSound = true;
  bool _smsAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: Navigator.canPop(context),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: ErisColors.primary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('ACCOUNT PROFILE'),
                  _accountCard(context),
                  const SizedBox(height: 24),
                  _sectionHeader('NOTIFICATION SETTINGS'),
                  _notificationCard(),
                  const SizedBox(height: 24),
                  _sectionHeader('LOCATION SERVICES'),
                  _locationCard(),
                  const SizedBox(height: 24),
                  _emergencyHeaderRow(),
                  _emergencyCard(),
                  const SizedBox(height: 24),
                  _sectionHeader('SYSTEM & SAFETY'),
                  _systemSafetyCard(context),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      'ERIS DISASTER RESPONSE SYSTEM V4.2.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ErisColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: ErisColors.textTertiary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _accountCard(BuildContext context) {
    return _card(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: ErisColors.surfaceVariant,
                child: Text(
                  'VR',
                  style: TextStyle(
                    color: ErisColors.primaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vihangi Ranasinghe',
                      style: TextStyle(
                        color: ErisColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'vihangi123@gmail.com',
                      style: TextStyle(
                        color: ErisColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: ErisColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notificationCard() {
    return _card(
      children: [
        _notifRow(
          iconBg: ErisColors.primary.withValues(alpha: 0.18),
          icon: Icons.notifications_outlined,
          iconColor: ErisColors.primary,
          title: 'Push Notifications',
          subtitle: 'Instant alerts for all disaster updates',
          value: _pushNotifications,
          onChanged: (v) => setState(() => _pushNotifications = v),
          showDividerBelow: true,
        ),
        _notifRow(
          iconBg: ErisColors.warning.withValues(alpha: 0.15),
          icon: Icons.campaign_outlined,
          iconColor: ErisColors.warning,
          title: 'Critical Sound Alerts',
          subtitle: 'Override silent mode for life-threatening events',
          value: _criticalSound,
          onChanged: (v) => setState(() => _criticalSound = v),
          showDividerBelow: true,
        ),
        _notifRow(
          iconBg: ErisColors.textTertiary.withValues(alpha: 0.2),
          icon: Icons.sms_outlined,
          iconColor: ErisColors.textSecondary,
          title: 'SMS Alerts',
          subtitle: 'Backup communication via text messaging',
          value: _smsAlerts,
          onChanged: (v) => setState(() => _smsAlerts = v),
          showDividerBelow: false,
        ),
      ],
    );
  }

  Widget _notifRow({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDividerBelow,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ErisColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: ErisColors.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: ErisColors.primary,
                inactiveThumbColor: const Color(0xFF9E9E9E),
                inactiveTrackColor: ErisColors.surfaceVariant,
              ),
            ],
          ),
        ),
        if (showDividerBelow) const Divider(height: 1, color: Colors.white10),
      ],
    );
  }

  Widget _locationCard() {
    return _card(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: ErisColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Current Status: ',
                style: TextStyle(color: ErisColors.textSecondary, fontSize: 14),
              ),
              const Text(
                'High Accuracy',
                style: TextStyle(
                  color: ErisColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.location_on_outlined, color: ErisColors.primary, size: 22),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/background_image.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: ErisColors.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Icon(Icons.map_outlined, color: ErisColors.textTertiary, size: 40),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trusted zones coming soon')),
                );
              },
              icon: const Icon(Icons.map_outlined, size: 20),
              label: const Text('Manage Trusted Zones', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ErisColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emergencyHeaderRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'EMERGENCY CONTACTS',
              style: TextStyle(
                color: ErisColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Add contact coming soon')),
          //     );
          //   },
          //   child: const Text(
          //     '+ Add New',
          //     style: TextStyle(
          //       color: ErisColors.primary,
          //       fontWeight: FontWeight.w700,
          //       fontSize: 13,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _emergencyCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: _card(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: ErisColors.primary,
                    child: const Text(
                      'SS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Abdul Raheem',
                              style: TextStyle(
                                color: ErisColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: ErisColors.warning.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'PRIMARY',
                                style: TextStyle(
                                  color: ErisColors.warning,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+94 77 2358 580',
                          style: TextStyle(
                            color: ErisColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _systemSafetyCard(BuildContext context) {
    return _card(
      children: [
        _systemRow(
          icon: Icons.shield_outlined,
          iconColor: ErisColors.primary,
          title: 'System Health Check',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ErisColors.success.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OPTIMAL',
              style: TextStyle(
                color: ErisColors.success,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          showDivider: true,
          onTap: () {},
        ),
        _systemRow(
          icon: Icons.description_outlined,
          iconColor: ErisColors.textSecondary,
          title: 'Privacy Policy',
          trailing: const Icon(Icons.open_in_new_rounded, color: ErisColors.textTertiary, size: 20),
          showDivider: true,
          onTap: () => Navigator.of(context).pushNamed('/privacy-policy'),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.logout_rounded, color: ErisColors.danger, size: 22),
                const SizedBox(width: 14),
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: ErisColors.danger,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _systemRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: ErisColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Colors.white10),
      ],
    );
  }
}
