import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Profile: personal info, activity, preferences — styled for [ErisTheme] (dark).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'English';
  /// Display preference only; app shell stays on [ErisTheme] (dark).
  bool _preferDarkUiAccent = true;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: ErisColors.background,
      appBar: AppBar(
        backgroundColor: ErisColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: ErisColors.primary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location & signal')),
              );
            },
            icon: const Icon(Icons.gps_fixed_rounded, color: ErisColors.primary, size: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          children: [
            _buildAvatarHeader(),
            const SizedBox(height: 28),
            _buildPersonalInfoCard(),
            const SizedBox(height: 16),
            _buildActivityCard(),
            const SizedBox(height: 16),
            _buildPreferencesCard(),
            const SizedBox(height: 24),
            _buildChangePasswordButton(),
            const SizedBox(height: 12),
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarHeader() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ErisColors.primary.withValues(alpha: 0.5), width: 2),
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: ErisColors.surfaceVariant,
                child: Text(
                  'VR',
                  style: TextStyle(
                    color: ErisColors.primaryLight,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit photo')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: ErisColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Vihangi Ranasinghe',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'vihangi123@gmail.com',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ErisColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return _profileCard(
      color: ErisColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, color: ErisColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Personal Information',
                style: TextStyle(
                  color: ErisColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoField('FULL NAME', 'Vihangi Ranasinghe'),
          const SizedBox(height: 16),
          _infoField('PHONE', '+94 77 123 4567'),
          const SizedBox(height: 16),
          _infoField('EMAIL ADDRESS', 'vihangi123@gmail.com'),
          const SizedBox(height: 16),
          _infoField(
            'RESIDENTIAL ADDRESS',
            'No 45, Marine Drive, Colombo 03, Sri Lanka',
          ),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ErisColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard() {
    return _profileCard(
      color: ErisColors.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, color: ErisColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Activity',
                style: TextStyle(
                  color: ErisColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Last Alert Received',
            style: TextStyle(
              color: ErisColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Flood Warning',
            style: TextStyle(
              color: ErisColors.danger,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '2 hours ago',
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Member Since',
            style: TextStyle(
              color: ErisColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'March 12, 2024',
            style: TextStyle(
              color: ErisColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return _profileCard(
      color: ErisColors.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, color: ErisColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Preferences',
                style: TextStyle(
                  color: ErisColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Language',
                  style: TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: ErisColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _language,
                    dropdownColor: ErisColors.surface,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ErisColors.textSecondary),
                    style: const TextStyle(
                      color: ErisColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'English', child: Text('English')),
                      DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
                      DropdownMenuItem(value: 'Sinhala', child: Text('Sinhala')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _language = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Theme',
                  style: TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.light_mode_rounded,
                color: _preferDarkUiAccent ? ErisColors.textTertiary : ErisColors.primaryLight,
                size: 22,
              ),
              const SizedBox(width: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) return Colors.white;
                      return const Color(0xFF9E9E9E);
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) return ErisColors.primary;
                      return ErisColors.surface;
                    }),
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
                child: Switch(
                  value: _preferDarkUiAccent,
                  onChanged: (v) {
                    setState(() => _preferDarkUiAccent = v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Eris uses the dark theme globally for a consistent experience.',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.dark_mode_rounded,
                color: _preferDarkUiAccent ? ErisColors.primaryLight : ErisColors.textTertiary,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileCard({
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Change password')),
          );
        },
        icon: const Icon(Icons.lock_reset_rounded, color: ErisColors.primary, size: 22),
        label: const Text(
          'Change Password',
          style: TextStyle(
            color: ErisColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: ErisColors.primary.withValues(alpha: 0.12),
          foregroundColor: ErisColors.textPrimary,
          side: const BorderSide(color: Colors.white12),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        icon: const Icon(Icons.logout_rounded, color: ErisColors.danger, size: 22),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            color: ErisColors.danger,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: ErisColors.danger.withValues(alpha: 0.12),
          foregroundColor: ErisColors.danger,
          side: BorderSide(color: ErisColors.danger.withValues(alpha: 0.35)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
