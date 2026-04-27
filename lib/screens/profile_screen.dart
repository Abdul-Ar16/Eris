import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/avatar_notifier.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Profile: personal info, activity, preferences — styled for [ErisTheme] (dark).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String _language = 'English';
  /// Display preference only; app shell stays on [ErisTheme] (dark).
  bool _preferDarkUiAccent = true;
  String? _avatarPath;
  String _fullName = 'User';
  String _email = '-';
  String _phoneNumber = '-';
  String _district = '-';
  String? _preferredLanguageCode;

  static const _kAvatarKey = 'profile_avatar_path';

  @override
  void initState() {
    super.initState();
    _loadAvatar();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await _authService.getProfile();
    if (!mounted) return;
    if (result['success'] != true || result['data'] == null) {
      final message = (result['message']?.toString().trim().isNotEmpty ?? false)
          ? result['message'].toString()
          : 'Failed to load profile.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    final data = result['data'] as Map<String, dynamic>;
    final langCode = (data['preferredLanguage'] ?? 'EN').toString().toUpperCase();

    setState(() {
      _fullName = (data['fullName'] ?? _fullName).toString();
      _email = (data['email'] ?? _email).toString();
      _phoneNumber = (data['phoneNumber'] ?? _phoneNumber).toString();
      _district = (data['district'] ?? _district).toString();
      _preferredLanguageCode = langCode;
      _language = _languageFromCode(langCode);
    });
  }

  String _languageFromCode(String code) {
    switch (code.toUpperCase()) {
      case 'SI':
        return 'Sinhala';
      case 'TA':
        return 'Tamil';
      case 'EN':
      default:
        return 'English';
    }
  }

  String _languageToCode(String language) {
    switch (language) {
      case 'Sinhala':
        return 'SI';
      case 'Tamil':
        return 'TA';
      case 'English':
      default:
        return 'EN';
    }
  }

  Future<void> _updatePreferredLanguage(String selectedLanguage) async {
    final selectedCode = _languageToCode(selectedLanguage);
    final result = await _authService.updateProfile(
      fullName: _fullName,
      phoneNumber: _phoneNumber,
      district: _district,
      preferredLanguage: selectedCode,
    );
    if (!mounted) return;
    if (result['success'] == true) {
      setState(() {
        _language = selectedLanguage;
        _preferredLanguageCode = selectedCode;
      });
      return;
    }

    final message = (result['message']?.toString().trim().isNotEmpty ?? false)
        ? result['message'].toString()
        : 'Failed to update language.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_kAvatarKey);
    final resolved = (path != null && File(path).existsSync()) ? path : null;
    avatarNotifier.value = resolved; // seed the global notifier
    if (mounted) setState(() => _avatarPath = resolved);
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // close bottom sheet
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 600,
    );
    if (file == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatarKey, file.path);
    avatarNotifier.value = file.path; // notify all listeners immediately
    setState(() => _avatarPath = file.path);
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ErisColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Profile Photo',
                style: TextStyle(
                  color: ErisColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how to update your profile picture.',
                style: TextStyle(
                  color: ErisColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              // Camera option
              _pickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: ErisColors.primary.withValues(alpha: 0.18),
                iconColor: ErisColors.primary,
                title: 'Take a Photo',
                subtitle: 'Use your camera to snap a new photo',
                onTap: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 10),
              // Gallery option
              _pickerOption(
                icon: Icons.photo_library_rounded,
                iconBg: ErisColors.primaryLight.withValues(alpha: 0.14),
                iconColor: ErisColors.primaryLight,
                title: 'Choose from Gallery',
                subtitle: 'Pick an existing photo from your device',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              if (_avatarPath != null) ...
              [
                const SizedBox(height: 10),
                _pickerOption(
                  icon: Icons.delete_outline_rounded,
                  iconBg: ErisColors.danger.withValues(alpha: 0.14),
                  iconColor: ErisColors.danger,
                  title: 'Remove Photo',
                  subtitle: 'Revert to your default initials avatar',
                  onTap: () async {
                    Navigator.of(context).pop();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove(_kAvatarKey);
                    avatarNotifier.value = null; // notify all listeners immediately
                    setState(() => _avatarPath = null);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickerOption({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ErisColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ErisColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ErisColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Location & signal')),
        //       );
        //     },
        //     icon: const Icon(Icons.gps_fixed_rounded, color: ErisColors.primary, size: 24),
        //   ),
        // ],
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
            GestureDetector(
              onTap: _showPickerSheet,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ErisColors.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: ErisColors.surfaceVariant,
                  backgroundImage: _avatarPath != null
                      ? FileImage(File(_avatarPath!))
                      : null,
                  child: _avatarPath == null
                      ? Text(
                          'VR',
                          style: TextStyle(
                            color: ErisColors.primaryLight,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: _showPickerSheet,
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
        Text(
          _fullName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _email,
          textAlign: TextAlign.center,
          style: const TextStyle(
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
          _infoField('FULL NAME', _fullName),
          const SizedBox(height: 16),
          _infoField('PHONE', _phoneNumber),
          const SizedBox(height: 16),
          _infoField('EMAIL ADDRESS', _email),
          const SizedBox(height: 16),
          _infoField(
            'RESIDENTIAL ADDRESS',
            _district,
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
                      if (v != null && v != _language) {
                        _updatePreferredLanguage(v);
                      }
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
          Navigator.of(context).pushNamed('/change-password');
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
