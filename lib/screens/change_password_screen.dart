import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Change Password screen — styled to match the Eris dark design system.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  double _strength = 0; // 0..1
  String _strengthLabel = '';
  Color _strengthColor = Colors.transparent;

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  // ── Password strength ────────────────────────────────────────────────────
  void _evaluateStrength(String pw) {
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
      _strength = pw.isEmpty ? 0 : score;
      _strengthLabel = pw.isEmpty ? '' : label;
      _strengthColor = color;
    });
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await _authService.changePassword(
      currentPassword: _currentPwCtrl.text,
      newPassword: _newPwCtrl.text,
    );
    if (!mounted) return;
    if (result['success'] != true) {
      final message = (result['message']?.toString().trim().isNotEmpty ?? false)
          ? result['message'].toString()
          : 'Failed to update password.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: ErisColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Password updated successfully!'),
          ],
        ),
        backgroundColor: ErisColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Clear fields after success
    _currentPwCtrl.clear();
    _newPwCtrl.clear();
    _confirmPwCtrl.clear();
    setState(() {
      _strength = 0;
      _strengthLabel = '';
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErisColors.background,
      appBar: AppBar(
        backgroundColor: ErisColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hint text ─────────────────────────────────────────────
              Text(
                'Your new password must be at least 8 characters long and include a mix of letters, numbers, and symbols.',
                style: TextStyle(
                  color: ErisColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // ── Current Password ──────────────────────────────────────
              _fieldLabel('CURRENT PASSWORD'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _currentPwCtrl,
                hintText: '••••••••',
                show: _showCurrent,
                onToggle: () => setState(() => _showCurrent = !_showCurrent),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your current password';
                  return null;
                },
                // trailing: GestureDetector(
                //   onTap: () {
                //     // TODO: navigate to forgot password flow
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Forgot password flow')),
                //     );
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.only(right: 14, bottom: 2),
                //     child: Text(
                //       'Forgot\nPassword?',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //         color: ErisColors.primary,
                //         fontSize: 12,
                //         fontWeight: FontWeight.w600,
                //         height: 1.3,
                //       ),
                //     ),
                //   ),
                // ),
              ),
              const SizedBox(height: 22),

              // ── New Password ──────────────────────────────────────────
              _fieldLabel('NEW PASSWORD'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _newPwCtrl,
                hintText: '••••••••',
                show: _showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
                onChanged: _evaluateStrength,
                validator: (v) {
                  if (v == null || v.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              // Strength bar
              if (_strength > 0) ...[
                const SizedBox(height: 10),
                _buildStrengthBar(),
              ],
              const SizedBox(height: 22),

              // ── Confirm New Password ──────────────────────────────────
              _fieldLabel('CONFIRM NEW PASSWORD'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _confirmPwCtrl,
                hintText: '••••••••',
                show: _showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
                validator: (v) {
                  if (v != _newPwCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // ── Update Button ─────────────────────────────────────────
              _buildUpdateButton(),
              const SizedBox(height: 36),

              // ── Secure Session Banner ─────────────────────────────────
              _buildSecureSessionBanner(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: ErisColors.textTertiary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.9,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool show,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? trailing,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        color: ErisColors.textPrimary,
        fontSize: 16,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: ErisColors.textTertiary,
          letterSpacing: 2,
          fontSize: 16,
        ),
        filled: true,
        fillColor: ErisColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          borderSide: BorderSide(color: ErisColors.danger.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ErisColors.danger, width: 1.5),
        ),
        suffixIcon: trailing != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  trailing,
                  IconButton(
                    icon: Icon(
                      show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: ErisColors.textTertiary,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  ),
                ],
              )
            : IconButton(
                icon: Icon(
                  show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: ErisColors.textTertiary,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
      ),
    );
  }

  Widget _buildStrengthBar() {
    // 4 segments
    const segments = 4;
    final filled = (_strength * segments).round().clamp(0, segments);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(segments, (i) {
              final active = i < filled;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.only(right: i < segments - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: active ? _strengthColor : Colors.white12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _strengthLabel,
            key: ValueKey(_strengthLabel),
            style: TextStyle(
              color: _strengthColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: ErisColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Update Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.lock_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSecureSessionBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ErisColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ErisColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sync_lock_rounded,
              color: ErisColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Secure Session',
            style: TextStyle(
              color: ErisColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Changing your password will sign you out of all other active sessions on your disaster response devices.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
