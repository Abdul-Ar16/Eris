import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// ──────────────────────────────────────────────────────────────────────────
///  Forgot-Password Flow — 3 steps:
///    1. Enter registered email
///    2. Verify OTP (6-digit code)
///    3. Set new password
/// ──────────────────────────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  // ── Step control ──────────────────────────────────────────────────────────
  int _step = 0; // 0 = Email, 1 = OTP, 2 = New Password

  // ── Controllers ───────────────────────────────────────────────────────────
  final _emailCtrl = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());

  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  final _newPwFormKey = GlobalKey<FormState>();

  bool _showNewPw = false;
  bool _showConfirmPw = false;
  double _pwStrength = 0;
  String _pwStrengthLabel = '';
  Color _pwStrengthColor = Colors.transparent;

  // ── OTP timer ─────────────────────────────────────────────────────────────
  int _secondsLeft = 60;
  Timer? _timer;
  bool _canResend = false;

  // ── Page-slide animation ──────────────────────────────────────────────────
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    for (final c in _otpCtrl) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    _timer?.cancel();
    _slideCtrl.dispose();
    super.dispose();
  }

  // ── Navigation helpers ────────────────────────────────────────────────────
  void _goTo(int step) {
    _slideCtrl.reset();
    setState(() => _step = step);
    _slideCtrl.forward();
  }

  // ── Step 1: Send OTP ──────────────────────────────────────────────────────
  void _sendOtp() {
    if (!_emailFormKey.currentState!.validate()) return;
    // TODO: trigger real OTP via auth backend
    _startResendTimer();
    _goTo(1);
  }

  // ── Step 2: Verify OTP ────────────────────────────────────────────────────
  String get _otpValue => _otpCtrl.map((c) => c.text).join();

  void _verifyOtp() {
    if (_otpValue.length < 6) {
      _showError('Please enter the complete 6-digit code.');
      return;
    }
    // TODO: verify against real OTP
    _timer?.cancel();
    _goTo(2);
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // ── Step 3: Reset password ────────────────────────────────────────────────
  void _resetPassword() {
    if (!_newPwFormKey.currentState!.validate()) return;
    // TODO: call auth backend to update password
    _showSuccess();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: ErisColors.danger,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: ErisColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ErisColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: ErisColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password Reset!',
              style: TextStyle(
                color: ErisColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your password has been updated successfully. Please log in with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ErisColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ErisColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Password strength ─────────────────────────────────────────────────────
  void _evalStrength(String pw) {
    double score = 0;
    if (pw.length >= 8) score += 0.25;
    if (pw.contains(RegExp(r'[A-Z]'))) score += 0.25;
    if (pw.contains(RegExp(r'[0-9]'))) score += 0.25;
    if (pw.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score += 0.25;

    String label;
    Color color;
    if (score <= 0.25) {
      label = 'Weak';
      color = ErisColors.danger;
    } else if (score <= 0.50) {
      label = 'Fair';
      color = ErisColors.warning;
    } else if (score <= 0.75) {
      label = 'Good';
      color = ErisColors.primaryLight;
    } else {
      label = 'Strong';
      color = ErisColors.success;
    }

    setState(() {
      _pwStrength = pw.isEmpty ? 0 : score;
      _pwStrengthLabel = pw.isEmpty ? '' : label;
      _pwStrengthColor = color;
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      appBar: AppBar(
        backgroundColor: ErisColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            if (_step > 0) {
              _goTo(_step - 1);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // ── Step indicator ─────────────────────────────────────────────
          _buildStepIndicator(),
          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                  child: _buildStep(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step indicator ────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    const labels = ['Email', 'Verify OTP', 'New Password'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Row(
              children: [
                // Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done || active
                        ? ErisColors.primary
                        : ErisColors.surfaceVariant,
                    border: Border.all(
                      color: active
                          ? ErisColors.primaryLight
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: ErisColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : ErisColors.textTertiary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                // Label
                Text(
                  labels[i],
                  style: TextStyle(
                    color: active
                        ? ErisColors.textPrimary
                        : ErisColors.textTertiary,
                    fontSize: 12,
                    fontWeight:
                        active ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                // Connector
                if (i < 2)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: i < _step
                            ? ErisColors.primary
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildNewPasswordStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Step 1 — Email ────────────────────────────────────────────────────────
  Widget _buildEmailStep() {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepIcon(Icons.lock_reset_rounded, ErisColors.primary),
          const SizedBox(height: 20),
          const Text(
            'Forgot Password?',
            style: TextStyle(
              color: ErisColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'No worries! Enter the email address linked to your Eris account and we\'ll send a verification code.',
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 32),
          _label('EMAIL ADDRESS'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: ErisColors.textPrimary),
            decoration: _inputDeco(
              hint: 'you@example.com',
              prefix: Icons.email_outlined,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter your email';
              final emailReg = RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$');
              if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 36),
          _primaryButton(
            label: 'Send Verification Code',
            icon: Icons.send_rounded,
            onPressed: _sendOtp,
          ),
          const SizedBox(height: 20),
          _secondaryButton(
            label: 'Back to Login',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ── Step 2 — OTP ─────────────────────────────────────────────────────────
  Widget _buildOtpStep() {
    final email = _emailCtrl.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepIcon(Icons.mark_email_read_rounded, ErisColors.primaryLight),
        const SizedBox(height: 20),
        const Text(
          'Check Your Email',
          style: TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: email,
                style: const TextStyle(
                  color: ErisColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '. Enter it below.'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // ── OTP boxes ─────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _otpBox(i)),
        ),
        const SizedBox(height: 28),
        // ── Resend timer ──────────────────────────────────────────────
        Center(
          child: _canResend
              ? GestureDetector(
                  onTap: () {
                    // TODO: call resend OTP API
                    _startResendTimer();
                  },
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(
                      color: ErisColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: ErisColors.textSecondary,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'Resend code in '),
                      TextSpan(
                        text: '${_secondsLeft}s',
                        style: const TextStyle(
                          color: ErisColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 36),
        _primaryButton(
          label: 'Verify Code',
          icon: Icons.verified_rounded,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 20),
        _secondaryButton(
          label: 'Use a different email',
          onPressed: () => _goTo(0),
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: _otpCtrl[index],
        focusNode: _otpFocus[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          color: ErisColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ErisColors.surfaceVariant,
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: ErisColors.primary, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            _otpFocus[index + 1].requestFocus();
          } else if (v.isEmpty && index > 0) {
            _otpFocus[index - 1].requestFocus();
          }
          setState(() {}); // rebuild for verify button state
        },
      ),
    );
  }

  // ── Step 3 — New Password ─────────────────────────────────────────────────
  Widget _buildNewPasswordStep() {
    return Form(
      key: _newPwFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepIcon(Icons.lock_rounded, ErisColors.success),
          const SizedBox(height: 20),
          const Text(
            'Set New Password',
            style: TextStyle(
              color: ErisColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create a strong password with at least 8 characters, including letters, numbers, and symbols.',
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 32),
          _label('NEW PASSWORD'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newPwCtrl,
            obscureText: !_showNewPw,
            onChanged: _evalStrength,
            style: const TextStyle(
              color: ErisColors.textPrimary,
              letterSpacing: 1.5,
            ),
            decoration: _inputDeco(
              hint: '••••••••',
              prefix: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _showNewPw
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: ErisColors.textTertiary,
                  size: 20,
                ),
                onPressed: () => setState(() => _showNewPw = !_showNewPw),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 8) {
                return 'Must be at least 8 characters';
              }
              return null;
            },
          ),
          if (_pwStrength > 0) ...[
            const SizedBox(height: 10),
            _strengthBar(),
          ],
          const SizedBox(height: 20),
          _label('CONFIRM NEW PASSWORD'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPwCtrl,
            obscureText: !_showConfirmPw,
            style: const TextStyle(
              color: ErisColors.textPrimary,
              letterSpacing: 1.5,
            ),
            decoration: _inputDeco(
              hint: '••••••••',
              prefix: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _showConfirmPw
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: ErisColors.textTertiary,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _showConfirmPw = !_showConfirmPw),
              ),
            ),
            validator: (v) {
              if (v != _newPwCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 36),
          _primaryButton(
            label: 'Reset Password',
            icon: Icons.check_rounded,
            onPressed: _resetPassword,
          ),
        ],
      ),
    );
  }

  // ── Shared widgets ────────────────────────────────────────────────────────

  Widget _stepIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: ErisColors.textTertiary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      );

  InputDecoration _inputDeco({
    required String hint,
    required IconData prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ErisColors.textTertiary),
      filled: true,
      fillColor: ErisColors.surfaceVariant,
      prefixIcon: Icon(prefix, color: ErisColors.textSecondary, size: 20),
      suffixIcon: suffix,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ErisColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: ErisColors.danger.withValues(alpha: 0.7)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ErisColors.danger, width: 1.5),
      ),
    );
  }

  Widget _strengthBar() {
    const segments = 4;
    final filled = (_pwStrength * segments).round().clamp(0, segments);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(segments, (i) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin:
                      EdgeInsets.only(right: i < segments - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: i < filled ? _pwStrengthColor : Colors.white12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _pwStrengthLabel,
            key: ValueKey(_pwStrengthLabel),
            style: TextStyle(
              color: _pwStrengthColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ErisColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: ErisColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
