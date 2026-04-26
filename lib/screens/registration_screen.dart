import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  int _currentPhase = 0;
  bool _isLoading = false;

  // Phase 3 — Alert preferences
  bool _prefFlood = true;
  bool _prefLandslide = true;
  bool _prefAllClear = true;
  bool _prefPush = true;
  bool _prefSms = false;
  bool _prefCriticalAudio = true;

  // Phase 4 — Emergency contact
  final _emergencyNameController = TextEditingController(text: 'Abdul Raheem');
  final _emergencyPhoneController = TextEditingController(text: '+94 72 77564 339');
  String _emergencyRelationship = 'Partner';
  bool _notifyHighAlerts = true;
  bool _shareLocationEmergency = false;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _zoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dropdown Values
  String _countryCode = '+94';
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedZone;

  // Form Validation Keys
  final _phase1Key = GlobalKey<FormState>();
  final _phase2Key = GlobalKey<FormState>();
  final _phase4Key = GlobalKey<FormState>();

  // Data lists
  final List<String> _provinces = ['Western', 'Central', 'Southern', 'Northern', 'Eastern', 'North Western', 'North Central', 'Uva', 'Sabaragamuwa'];
  final Map<String, List<String>> _districtsMap = {
    'Western': ['Colombo', 'Gampaha', 'Kalutara'],
    'Central': ['Kandy', 'Matale', 'Nuwara Eliya'],
    'Southern': ['Galle', 'Matara', 'Hambantota'],
    'Northern': ['Jaffna', 'Kilinochchi', 'Mannar', 'Vavuniya', 'Mullaitivu'],
    'Eastern': ['Trincomalee', 'Batticaloa', 'Ampara'],
  };
  final Map<String, List<String>> _zonesMap = {
    'Colombo': ['Colombo 01', 'Colombo 03', 'Battaramullah', 'Dehiwala', 'Mount Lavinia'],
    'Gampaha': ['Gampaha Town', 'Negombo', 'Kelaniya', 'Wattala'],
    'Kandy': ['Kandy City', 'Peradeniya', 'Katugastota'],
  };

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
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _nextPhase() async {
    // Phase 1 Validation
    if (_currentPhase == 0) {
      if (_nameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
        _showError('Please fill in all basic details.');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('Passwords do not match.');
        return;
      }
    }

    // Phase 2 Validation
    if (_currentPhase == 1) {
      if (_selectedProvince == null || _selectedDistrict == null || _selectedZone == null) {
        _showError('Please select your complete location.');
        return;
      }
    }

    // Phase 4 Validation
    if (_currentPhase == 3) {
      if (_emergencyNameController.text.isEmpty || _emergencyPhoneController.text.isEmpty) {
        _showError('Please provide an emergency contact.');
        return;
      }
    }

    if (_currentPhase < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _isLoading = true);
      
      final result = await _authService.registerUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: '$_countryCode${_phoneController.text.trim()}',
        district: _selectedDistrict ?? 'Unknown',
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green),
          );
           Navigator.of(context).pushReplacementNamed('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Registration failed'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
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
            if (_currentPhase == 4) _buildPhase5Footer() else _buildCustomFooter(),
          ],
        ),
      ),
    );
  }

  void _goToHome() {
     Navigator.of(context).pushReplacementNamed('/login');
  }

  String get _summaryDisplayName {
    final t = _nameController.text.trim();
    return t.isEmpty ? 'Vihangi Ranasinghe' : t;
  }

  String get _summaryDisplayEmail {
    final t = _emailController.text.trim();
    return t.isEmpty ? 'vihangi123@gmail.com' : t;
  }

  String get _summaryEmergencyName {
    final t = _emergencyNameController.text.trim();
    return t.isEmpty ? 'Abdul Raheem' : t;
  }

  String get _summaryEmergencyPhone {
    final t = _emergencyPhoneController.text.trim();
    return t.isEmpty ? '+94 72 77564 339' : t;
  }

  String get _summaryEmergencySubtitle {
    final p = _summaryEmergencyPhone;
    return 'Primary Relation • $p';
  }

  Widget _buildCustomHeader() {
    final phase4 = _currentPhase == 3;
    final phase5 = _currentPhase == 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _previousPhase,
            icon: const Icon(Icons.arrow_back, color: ErisColors.primary),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              phase5 ? 'Registration Complete' : 'Registration',
              style: const TextStyle(
                color: ErisColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (phase4 || phase5)
            const Text(
              'ERIS',
              style: TextStyle(
                color: ErisColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            )
          else
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
                width: 85,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: ErisColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _countryCode,
                    dropdownColor: ErisColors.surface,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 16),
                    items: ['+94', '+1', '+44', '+91'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _countryCode = v!),
                  ),
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
          _buildDropdownField(
            hint: 'Select Province',
            value: _selectedProvince,
            items: _provinces,
            onChanged: (v) => setState(() {
              _selectedProvince = v;
              _selectedDistrict = null;
              _selectedZone = null;
            }),
          ),
          const SizedBox(height: 20),
          _buildLabel('District'),
          _buildDropdownField(
            hint: 'Select District',
            value: _selectedDistrict,
            items: _selectedProvince != null ? (_districtsMap[_selectedProvince!] ?? []) : [],
            onChanged: (v) => setState(() {
              _selectedDistrict = v;
              _selectedZone = null;
            }),
          ),
          const SizedBox(height: 20),
          _buildLabel('Zone / Area'),
          _buildDropdownField(
            hint: 'Select Zone',
            value: _selectedZone,
            items: _selectedDistrict != null ? (_zonesMap[_selectedDistrict!] ?? ['Other']) : [],
            onChanged: (v) => setState(() => _selectedZone = v),
          ),
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

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.white38, fontSize: 14)),
          isExpanded: true,
          dropdownColor: ErisColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
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
            return const Color(0xFF9E9E9E);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return ErisColors.primary;
            return ErisColors.surfaceVariant;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STEP 3 OF 5',
              style: TextStyle(color: ErisColors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Alert Preferences',
                  style: TextStyle(color: ErisColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '60% Complete',
                  style: TextStyle(color: ErisColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.white10,
                color: ErisColors.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose which disasters you want to monitor and how you\'d like to be notified.',
              style: TextStyle(color: ErisColors.textSecondary, fontSize: 14, height: 1.45),
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
                      iconBg: ErisColors.primary.withValues(alpha: 0.18),
                      iconColor: ErisColors.primary,
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
                      iconBg: ErisColors.warning.withValues(alpha: 0.12),
                      iconColor: ErisColors.floodWarning,
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
        color: ErisColors.textTertiary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  BoxDecoration _phase3SurfaceCardDecoration() {
    return BoxDecoration(
      color: ErisColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white10),
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
      decoration: _phase3SurfaceCardDecoration(),
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
              color: ErisColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: ErisColors.textSecondary,
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
        color: ErisColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ErisColors.primary.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.verified_user, color: ErisColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All-Clear Reports',
                  style: TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Notifications when danger has passed',
                  style: TextStyle(
                    color: ErisColors.textSecondary,
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
      decoration: _phase3SurfaceCardDecoration(),
      child: Row(
        children: [
          Icon(icon, color: ErisColors.textSecondary, size: 26),
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
            color: ErisColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ErisColors.primary.withValues(alpha: 0.22)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety First',
                style: TextStyle(
                  color: ErisColors.primaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'During high-risk weather, push notifications will include evacuation routes specific to your location.',
                style: TextStyle(
                  color: ErisColors.textSecondary,
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
            color: ErisColors.primary.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
  Widget _buildPhase4() {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return const Color(0xFF9E9E9E);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return ErisColors.primary;
            return ErisColors.surfaceVariant;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STEP 4 OF 5',
              style: TextStyle(color: ErisColors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Emergency Contact',
                  style: TextStyle(color: ErisColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '80% Complete',
                  style: TextStyle(color: ErisColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.white10,
                color: ErisColors.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 20),
            _buildPhase4InfoBanner(),
            const SizedBox(height: 24),
            _buildPhase4FieldLabel('Full Name'),
            _buildPhase4TextField(
              controller: _emergencyNameController,
              hint: 'Enter Full Name',
              suffix: const Icon(Icons.person_outline_rounded, color: ErisColors.textSecondary, size: 22),
            ),
            const SizedBox(height: 20),
            _buildPhase4FieldLabel('Relationship'),
            _buildPhase4RelationshipField(),
            const SizedBox(height: 20),
            _buildPhase4FieldLabel('Mobile Number'),
            _buildPhase4TextField(
              controller: _emergencyPhoneController,
              hint: 'Enter Mobile Number',
              suffix: const Icon(Icons.phone_android_rounded, color: ErisColors.textSecondary, size: 22),
            ),
            const SizedBox(height: 24),
            _buildPhase4ToggleRow(
              icon: Icons.notifications_active_outlined,
              title: 'Notify on HIGH alerts',
              subtitle: 'Send SMS during emergencies',
              value: _notifyHighAlerts,
              onChanged: (v) => setState(() => _notifyHighAlerts = v),
            ),
            const SizedBox(height: 12),
            _buildPhase4ToggleRow(
              icon: Icons.location_on_outlined,
              title: 'Share location',
              subtitle: 'Real-time GPS tracking access',
              value: _shareLocationEmergency,
              onChanged: (v) => setState(() => _shareLocationEmergency = v),
            ),
            const SizedBox(height: 24),
            _buildPhase4ProtocolGraphic(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase4InfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E3F5).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ErisColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ErisColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shield_outlined, color: ErisColors.primary, size: 24),
                Positioned(
                  bottom: 6,
                  child: Icon(Icons.person, size: 12, color: ErisColors.primary.withValues(alpha: 0.95)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'In case of an incident, we will automatically notify this person and share your last known coordinates. Ensure they are available to respond.',
              style: TextStyle(
                color: ErisColors.textSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase4FieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: ErisColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPhase4TextField({
    required TextEditingController controller,
    required String hint,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: ErisColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ErisColors.textTertiary),
        filled: true,
        fillColor: ErisColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ErisColors.primary, width: 1.5),
        ),
        suffixIcon: suffix,
      ),
    );
  }

  Widget _buildPhase4RelationshipField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: ErisColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _emergencyRelationship,
          isExpanded: true,
          dropdownColor: ErisColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ErisColors.textSecondary),
          style: const TextStyle(color: ErisColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
          items: const [
            DropdownMenuItem(value: 'Family', child: Text('Family')),
            DropdownMenuItem(value: 'Friend', child: Text('Friend')),
            DropdownMenuItem(value: 'Partner', child: Text('Partner')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _emergencyRelationship = v);
          },
        ),
      ),
    );
  }

  Widget _buildPhase4ToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ErisColors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ErisColors.primary, size: 22),
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

  Widget _buildPhase4ProtocolGraphic() {
    const grayscale = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: grayscale,
              child: Image.asset(
                'assets/background_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: ErisColors.surfaceVariant,
                  alignment: Alignment.center,
                  child: const Icon(Icons.map_outlined, color: ErisColors.textTertiary, size: 40),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: ErisColors.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PROTOCOL ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPhase5() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STEP 5 OF 5',
                style: TextStyle(color: ErisColors.primary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              Text(
                '100% Complete',
                style: TextStyle(color: ErisColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1,
              minHeight: 8,
              backgroundColor: Colors.white10,
              color: ErisColors.success,
            ),
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ErisColors.success.withValues(alpha: 0.45),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: ErisColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'You\'re all set!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ErisColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your professional profile has been created. Review your details below before heading to your dashboard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          _buildPhase5BasicInfoCard(),
          const SizedBox(height: 14),
          _buildPhase5LocationCard(),
          const SizedBox(height: 14),
          _buildPhase5AlertPrefsCard(),
          const SizedBox(height: 14),
          _buildPhase5EmergencyCard(),
        ],
      ),
    );
  }

  BoxDecoration _phase5CardDecoration() {
    return BoxDecoration(
      color: ErisColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white10),
    );
  }

  Widget _buildPhase5IconTile(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(icon, color: ErisColors.primary, size: 22),
    );
  }

  Widget _buildPhase5BasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _phase5CardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhase5IconTile(Icons.person_outline_rounded),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FULL NAME',
                  style: TextStyle(
                    color: ErisColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _summaryDisplayName,
                  style: const TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'EMAIL ADDRESS',
                  style: TextStyle(
                    color: ErisColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _summaryDisplayEmail,
                  style: const TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase5LocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _phase5CardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhase5IconTile(Icons.location_on_outlined),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Battaramullah Kannatta Road',
                      style: TextStyle(
                        color: ErisColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Colombo, Sri Lanka',
                      style: TextStyle(
                        color: ErisColors.textSecondary,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 64,
              width: double.infinity,
              child: Image.asset(
                'assets/background_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: ErisColors.surfaceVariant,
                  alignment: Alignment.center,
                  child: const Icon(Icons.map_outlined, color: ErisColors.primary, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase5AlertPrefsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _phase5CardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhase5IconTile(Icons.notifications_outlined),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ErisColors.success.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: ErisColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPhase5Tag('Real-time Push'),
                    _buildPhase5Tag('Daily Digest'),
                    _buildPhase5Tag('Critical SMS'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase5Tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: ErisColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPhase5EmergencyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _phase5CardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ErisColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.badge_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _summaryEmergencyName,
                  style: const TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _summaryEmergencySubtitle,
                  style: TextStyle(
                    color: ErisColors.textSecondary,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: ErisColors.surfaceVariant,
            child: Icon(Icons.person_rounded, color: ErisColors.primary.withValues(alpha: 0.9), size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase5Footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPhase,
              style: ElevatedButton.styleFrom(
                backgroundColor: ErisColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Go to Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Profile ID: #USR-992-881-A',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _previousPhase,
                style: TextButton.styleFrom(
                  foregroundColor: ErisColors.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 18, color: ErisColors.textSecondary),
                    SizedBox(width: 4),
                    Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _nextPhase,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(148, 54),
                  backgroundColor: ErisColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _previousPhase,
              style: TextButton.styleFrom(
                foregroundColor: ErisColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: _currentPhase == 3
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 18, color: ErisColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: _nextPhase,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(_currentPhase == 3 ? 200 : 148, 54),
                backgroundColor: ErisColors.primary,
                foregroundColor: Colors.white,
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
    );
  }
}
