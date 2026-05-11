import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/avatar_notifier.dart';
import '../services/auth_service.dart';
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
  final AuthService _authService = AuthService();
  bool _pushNotifications = true;
  bool _criticalSound = true;
  bool _smsAlerts = false;

  String _userName = 'User Name';
  String _userEmail = 'email@example.com';
  String _initials = 'U';

  // Emergency contact (loaded from DB via profile API)
  String _emergencyName = '-';
  String _emergencyPhone = '-';
  String _emergencyRelationship = '-';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'User Name';
    final email = prefs.getString('user_email') ?? 'email@example.com';

    // Generate initials from name
    String initials = '';
    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      final parts = trimmedName.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        initials = (parts.first[0] + parts.last[0]).toUpperCase();
      } else if (parts.first.isNotEmpty) {
        initials = parts.first[0].toUpperCase();
      }
    }

    if (mounted) {
      setState(() {
        _userName = name;
        _userEmail = email;
        _initials = initials.isEmpty ? 'U' : initials;
      });
    }

    // Load emergency contact from the profile API
    final result = await _authService.getProfile();
    if (!mounted) return;
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      final ecName = data['emergencyContactName'];
      final ecPhone = data['emergencyContactPhone'];
      final ecRel  = data['emergencyContactRelationship'];
      setState(() {
        _emergencyName         = (ecName  != null && ecName.toString().isNotEmpty)  ? ecName.toString()  : '-';
        _emergencyPhone        = (ecPhone != null && ecPhone.toString().isNotEmpty) ? ecPhone.toString() : '-';
        _emergencyRelationship = (ecRel   != null && ecRel.toString().isNotEmpty)   ? ecRel.toString()   : '-';
      });
    }
  }

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
                  const Center(
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
              ValueListenableBuilder<String?>(
                valueListenable: avatarNotifier,
                builder: (context, path, _) {
                  return CircleAvatar(
                    radius: 28,
                    backgroundColor: ErisColors.surfaceVariant,
                    backgroundImage:
                        path != null ? FileImage(File(path)) : null,
                    child: path == null
                        ? Text(
                            _initials,
                            style: const TextStyle(
                              color: ErisColors.primaryLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: ErisColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        color: ErisColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                  // Refresh data when returning from profile screen
                  _loadUserData();
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
          GestureDetector(
            onTap: () {
              // Add contact logic
            },
            child: const Text(
              'Manage',
              style: TextStyle(
                color: ErisColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyCard() {
    return _card(
      children: [
        _contactItem(
          label: _emergencyName,
          subtitle: _emergencyRelationship,
          phone: _emergencyPhone,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _contactItem({
    required String label,
    required String subtitle,
    required String phone,
    bool isPrimary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ErisColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_outline, color: ErisColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: const TextStyle(color: ErisColors.textPrimary, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPrimary) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ErisColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRIMARY',
                          style: TextStyle(color: ErisColors.primary, fontSize: 8, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: ErisColors.textSecondary, fontSize: 12),
                ),
                Text(
                  phone,
                  style: const TextStyle(color: ErisColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
        ],
      ),
    );
  }

  Widget _systemSafetyCard(BuildContext context) {
    return _card(
      children: [
        _systemRow(
          icon: Icons.shield_outlined,
          title: 'Safety Check Protocol',
          onTap: () {},
        ),
        const Divider(height: 1, color: Colors.white10),
        _systemRow(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support Center',
          onTap: () {},
        ),
        const Divider(height: 1, color: Colors.white10),
        _systemRow(
          icon: Icons.logout_rounded,
          title: 'Logout',
          titleColor: Colors.redAccent,
          onTap: () async {
            // Confirm logout
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: ErisColors.surface,
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await _authService.logout();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _systemRow({
    required IconData icon,
    required String title,
    Color titleColor = ErisColors.textPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: titleColor.withValues(alpha: 0.7), size: 22),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}
