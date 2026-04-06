import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentPhase = 0;

  // Phase 3 — Alert preferences
  bool _prefFlood = true;
  bool _prefLandslide = true;
  bool _prefAllClear = true;
  bool _prefPush = true;
  bool _prefSms = false;
  bool _prefCriticalAudio = true;

  /// Step 3 (Alert Preferences) — matches design reference (#F9F9FF bg, #3B59F8 accent).
  static const Color _phase3Bg = Color(0xFFF9F9FF);
  static const Color _phase3Blue = Color(0xFF3B59F8);
  static const Color _regTextDark = Color(0xFF1A1D26);
  static const Color _regTextMuted = Color(0xFF6B7280);
  static const Color _regSectionLabel = Color(0xFF9CA3AF);
  static const Color _regAllClearCardBg = Color(0xFFEDEEF8);
  static const Color _regSafetyBanner = Color(0xFFE8EEFC);
  static const Color _regSafetyBody = Color(0xFF1E40AF);

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _zoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _zoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPhase() {
    if (_currentPhase < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void _previousPhase() {
    if (_currentPhase > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool get _isAlertPreferencesPhase => _currentPhase == 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isAlertPreferencesPhase ? _phase3Bg : Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPhase = index),
                children: [
                  _buildPhase1(),
                  _buildPhase2(), // Updated phase 2: Location
                  _buildPhase3(),
                  _buildPhase4(),
                  _buildPhase5(),
                ],
              ),
            ),
            _buildCustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    final light = _isAlertPreferencesPhase;
    if (light) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _previousPhase,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  icon: const Icon(Icons.arrow_back, color: _phase3Blue, size: 22),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Registration',
                  style: TextStyle(
                    color: _regTextDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Step 3 of 5',
                  style: TextStyle(
                    color: _regTextDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '60% Complete',
                  style: TextStyle(
                    color: _phase3Blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.6,
                minHeight: 6,
                backgroundColor: Color(0xFFE5E7EB),
                color: _phase3Blue,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _previousPhase,
            icon: const Icon(Icons.arrow_back, color: ErisColors.primary),
          ),
          const SizedBox(width: 4),
          const Text(
            'Registration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.help_outline,
            color: Colors.white24,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildPhase1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create your account',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join our professional community. Let\'s start with your basic identification details.',
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 32),
          _buildLabel('Full Name'),
          _buildTextField(_nameController, 'Enter your legal name'),
          const SizedBox(height: 20),
          _buildLabel('Mobile Number'),
          Row(
            children: [
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: ErisColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Row(
                  children: [
                    Text('+1', style: TextStyle(color: Colors.white)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(_phoneController, '(555) 000-0000')),
            ],
          ),
          const SizedBox(height: 20),
          _buildLabel('Email Address'),
          _buildTextField(_emailController, 'name@company.com'),
          const SizedBox(height: 20),
          _buildLabel('Password'),
          _buildTextField(_passwordController, 'secret_pass', isPassword: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStrengthBar(true),
              _buildStrengthBar(true),
              _buildStrengthBar(false),
              _buildStrengthBar(false),
              const SizedBox(width: 8),
              const Text('MODERATE STRENGTH', style: TextStyle(color: ErisColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('Add symbols', style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 20),
          _buildLabel('Confirm Password'),
          _buildTextField(_confirmPasswordController, 'Repeat your password', isPassword: true),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ErisColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ErisColors.primary.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: ErisColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Privacy Guaranteed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Your information is encrypted with bank-grade security protocols.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STEP 2 OF 5',
            style: TextStyle(color: ErisColors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Your Location',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                '40% Complete',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.white10,
              color: ErisColors.primary,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9).withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.green.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.gps_fixed, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Use Current Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Auto-detect via GPS for better accuracy', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'OR ENTER MANUALLY',
              style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          _buildLabel('Province'),
          _buildDropdownField('Select Province'),
          const SizedBox(height: 20),
          _buildLabel('District'),
          _buildDropdownField('Select District'),
          const SizedBox(height: 20),
          _buildLabel('Zone / Area'),
          _buildDropdownField('Select Zone'),
          const SizedBox(height: 32),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: AssetImage('assets/map_preview.png'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'GPS Active: Signal Strength Strong',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    'VIEW FULL MAP',
                    style: TextStyle(color: ErisColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.white38, fontSize: 14)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: ErisColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, color: Colors.white24, size: 20) : null,
      ),
    );
  }

  Widget _buildStrengthBar(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      height: 3,
      width: 40,
      decoration: BoxDecoration(
        color: active ? ErisColors.primary : Colors.white10,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPhase3() {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return const Color(0xFF9CA3AF);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _phase3Blue;
            return const Color(0xFFE5E7EB);
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alert Preferences',
              style: TextStyle(
                color: _regTextDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose which disasters you want to monitor and how you\'d like to be notified.',
              style: TextStyle(
                color: _regTextMuted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            _buildPhase3SectionLabel('DISASTER TYPES'),
            const SizedBox(height: 12),
            SizedBox(
              height: 152,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildPhase3DisasterSmallCard(
                      iconBg: const Color(0xFFE3F2FD),
                      iconColor: _phase3Blue,
                      icon: Icons.flood,
                      title: 'Flood',
                      subtitle: 'Rising water levels',
                      value: _prefFlood,
                      onChanged: (v) => setState(() => _prefFlood = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPhase3DisasterSmallCard(
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFE65100),
                      icon: Icons.landslide,
                      title: 'Landslide',
                      subtitle: 'Terrain instability',
                      value: _prefLandslide,
                      onChanged: (v) => setState(() => _prefLandslide = v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildPhase3AllClearCard(),
            const SizedBox(height: 28),
            _buildPhase3SectionLabel('NOTIFICATION CHANNELS'),
            const SizedBox(height: 12),
            _buildPhase3NotificationCard(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Instant app alerts',
              value: _prefPush,
              onChanged: (v) => setState(() => _prefPush = v),
            ),
            const SizedBox(height: 10),
            _buildPhase3NotificationCard(
              icon: Icons.sms_outlined,
              title: 'SMS Alerts',
              subtitle: 'Critical messages via text',
              value: _prefSms,
              onChanged: (v) => setState(() => _prefSms = v),
            ),
            const SizedBox(height: 10),
            _buildPhase3NotificationCard(
              icon: Icons.volume_up_outlined,
              title: 'Critical Audio',
              subtitle: 'Override silent mode for danger',
              value: _prefCriticalAudio,
              onChanged: (v) => setState(() => _prefCriticalAudio = v),
            ),
            const SizedBox(height: 24),
            _buildPhase3SafetyBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase3SectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _regSectionLabel,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  BoxShadow _phase3CardShadow() {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 10,
      offset: const Offset(0, 3),
    );
  }

  Widget _buildPhase3DisasterSmallCard({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [_phase3CardShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const Spacer(),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: _regTextDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: _regTextMuted,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase3AllClearCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _regAllClearCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
        BoxShadow(
            color: _phase3Blue.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.verified_user, color: _phase3Blue, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All-Clear Reports',
                  style: TextStyle(
                    color: _regTextDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Notifications when danger has passed',
                  style: TextStyle(
                    color: _regTextMuted,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _prefAllClear,
            onChanged: (v) => setState(() => _prefAllClear = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase3NotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [_phase3CardShadow()],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5C6370), size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _regTextDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _regTextMuted,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildPhase3SafetyBanner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 72, 16),
          decoration: BoxDecoration(
            color: _regSafetyBanner,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety First',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'During high-risk weather, push notifications will include evacuation routes specific to your location.',
                style: TextStyle(
                  color: _regSafetyBody,
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Icon(
            Icons.shield_outlined,
            size: 72,
            color: _phase3Blue.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
  Widget _buildPhase4() => const Center(child: Text('Step 4: Preferences', style: TextStyle(color: Colors.white)));
  Widget _buildPhase5() => const Center(child: Text('Step 5: Review', style: TextStyle(color: Colors.white)));

  Widget _buildCustomFooter() {
    final light = _isAlertPreferencesPhase;
    return Container(
      width: double.infinity,
      decoration: light
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _previousPhase,
              style: TextButton.styleFrom(
                foregroundColor: light ? _regTextDark : Colors.white70,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: light
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 18, color: _regTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: _regTextDark.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  : const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: _nextPhase,
              style: ElevatedButton.styleFrom(
                minimumSize: light ? const Size(200, 54) : const Size(148, 54),
                backgroundColor: light ? _phase3Blue : ErisColors.primary,
                foregroundColor: Colors.white,
                elevation: light ? 0 : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_currentPhase == 4 ? 'Finish' : 'Continue', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
