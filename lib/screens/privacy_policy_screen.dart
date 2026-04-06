import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Privacy Policy — full scrollable document styled for the Eris dark design system.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(
            color: ErisColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────────────────
            _heroBanner(),
            const SizedBox(height: 28),

            // ── Sections ─────────────────────────────────────────────────
            _section(
              icon: Icons.info_outline_rounded,
              iconColor: ErisColors.primary,
              title: '1. Introduction',
              body:
                  'Eris Disaster Response System ("Eris", "we", "our") is committed to protecting your personal information. '
                  'This Privacy Policy explains how we collect, use, disclose, and safeguard your data when you use the Eris mobile application. '
                  'By using Eris you agree to the practices described herein.',
            ),
            _divider(),

            _section(
              icon: Icons.storage_rounded,
              iconColor: ErisColors.primaryLight,
              title: '2. Information We Collect',
              body: null,
              bullets: const [
                'Account data: name, email address, phone number, and residential address provided during registration.',
                'Location data: real-time GPS coordinates used to deliver area-specific disaster alerts.',
                'Device information: device model, OS version, push notification token.',
                'Usage analytics: screens visited, feature interactions, and session duration (anonymised).',
                'Emergency contacts: names and phone numbers you voluntarily add.',
              ],
            ),
            _divider(),

            _section(
              icon: Icons.track_changes_rounded,
              iconColor: ErisColors.warning,
              title: '3. How We Use Your Information',
              body: null,
              bullets: const [
                'Sending real-time disaster alerts tailored to your verified location.',
                'Notifying your emergency contacts during SOS activations.',
                'Improving Eris features, performance, and reliability.',
                'Complying with applicable laws and government disaster-response mandates.',
                'Communicating service updates, security notices, and policy changes.',
              ],
            ),
            _divider(),

            _section(
              icon: Icons.location_on_rounded,
              iconColor: ErisColors.danger,
              title: '4. Location Services',
              body:
                  'Eris requires continuous background location access to detect when you enter or leave disaster-affected zones and to route evacuation guidance accurately. '
                  'Location data is encrypted in transit and retained for no longer than 30 days. '
                  'You may revoke location permission at any time in your device settings; doing so will disable real-time alert delivery.',
            ),
            _divider(),

            _section(
              icon: Icons.share_rounded,
              iconColor: ErisColors.primaryLight,
              title: '5. Information Sharing',
              body:
                  'We do not sell your personal data. We may share information with:',
              bullets: const [
                'Government emergency management agencies, solely to coordinate disaster relief.',
                'Trusted service providers (e.g., cloud hosting, push notification services) under strict confidentiality agreements.',
                'Law-enforcement or regulatory authorities when required by law or to protect safety.',
              ],
            ),
            _divider(),

            _section(
              icon: Icons.verified_user_rounded,
              iconColor: ErisColors.success,
              title: '6. Your Rights',
              body: null,
              bullets: const [
                'Access a copy of the personal data we hold about you.',
                'Request correction of inaccurate or incomplete data.',
                'Request deletion of your account and associated data.',
                'Opt out of non-essential communications at any time.',
                'Lodge a complaint with the relevant data-protection authority.',
              ],
            ),
            _divider(),

            _section(
              icon: Icons.security_rounded,
              iconColor: ErisColors.primary,
              title: '7. Data Security',
              body:
                  'All data is encrypted at rest (AES-256) and in transit (TLS 1.3). '
                  'We enforce role-based access controls, conduct regular security audits, and follow responsible disclosure practices. '
                  'Despite these measures, no system is entirely immune to risk; we encourage you to use a strong, unique password and enable two-factor authentication.',
            ),
            _divider(),

            _section(
              icon: Icons.update_rounded,
              iconColor: ErisColors.warning,
              title: '8. Changes to This Policy',
              body:
                  'We may update this Privacy Policy periodically. When significant changes are made we will notify you via in-app banner and push notification at least 7 days before the changes take effect. '
                  'Continued use of Eris after that date constitutes acceptance of the revised policy.',
            ),
            _divider(),

            _section(
              icon: Icons.mail_outline_rounded,
              iconColor: ErisColors.primaryLight,
              title: '9. Contact Us',
              body:
                  'For privacy-related enquiries, data-access requests, or complaints, please contact our Data Protection Officer:\n\n'
                  'Email: privacy@eris-response.app\n'
                  'Address: Eris Systems Ltd., No. 45 Marine Drive, Colombo 03, Sri Lanka',
            ),

            const SizedBox(height: 28),

            // ── Effective date footer ─────────────────────────────────────
            _footer(),
          ],
        ),
      ),
    );
  }

  // ── Widgets ──────────────────────────────────────────────────────────────

  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ErisColors.primary.withValues(alpha: 0.22),
            ErisColors.primaryLight.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ErisColors.primary.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ErisColors.primary.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.policy_rounded,
              color: ErisColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters',
                  style: TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We collect only what is needed to keep you safe during disasters. '
                  'Read below to understand your rights.',
                  style: TextStyle(
                    color: ErisColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? body,
    List<String>? bullets,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: ErisColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Body text
          if (body != null)
            Text(
              body,
              style: const TextStyle(
                color: ErisColors.textSecondary,
                fontSize: 14,
                height: 1.65,
              ),
            ),
          // Bullet list
          if (bullets != null) ...[
            if (body != null) const SizedBox(height: 8),
            ...bullets.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ErisColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          color: ErisColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, color: Colors.white10),
    );
  }

  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ErisColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified_rounded, color: ErisColors.success, size: 26),
          const SizedBox(height: 8),
          const Text(
            'Effective Date: 1 January 2025',
            style: TextStyle(
              color: ErisColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ERIS DISASTER RESPONSE SYSTEM V4.2.0',
            style: TextStyle(
              color: ErisColors.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
