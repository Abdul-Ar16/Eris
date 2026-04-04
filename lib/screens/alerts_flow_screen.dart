import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AlertsFlowScreen extends StatefulWidget {
  const AlertsFlowScreen({super.key});

  @override
  State<AlertsFlowScreen> createState() => _AlertsFlowScreenState();
}

class _AlertsFlowScreenState extends State<AlertsFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    )
                  else
                    const SizedBox(width: 48),
                  TextButton(
                    onPressed: () {
                      // Skip or finish logic
                    },
                    child: const Text('Skip', style: TextStyle(color: Colors.white38)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildFirstPage(),
                  _buildSecondPage(),
                  _buildThirdPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Finish
                      }
                    },
                    child: Text(_currentPage == 2 ? 'GET STARTED' : 'CONTINUE'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? ErisColors.primary : Colors.white12,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFirstPage() {
    return _OnboardingContent(
      title: 'DISASTER ALERT',
      subtitle: 'EARLY WARNING SYSTEM',
      description: 'Stay ahead of floods and landslides. Get real-time alerts, evacuation routes, and safety guidance.',
      icon: Icons.emergency_share_rounded,
      iconColor: ErisColors.danger,
    );
  }

  Widget _buildSecondPage() {
    return _OnboardingContent(
      title: 'REAL-TIME ALERTS',
      subtitle: 'STAY INFORMED',
      description: 'The moment our sensors detect rising water levels or unstable soil conditions, you\'ll be the first to know.',
      icon: Icons.notifications_active_rounded,
      iconColor: ErisColors.warning,
      extra: Column(
        children: [
          const SizedBox(height: 32),
          _AlertPreviewCard(
            title: 'Flood risk detected',
            location: 'Colombo 05',
            severity: 'HIGH',
            color: ErisColors.riskHigh,
          ),
          const SizedBox(height: 12),
          _AlertPreviewCard(
            title: 'Landslide warning',
            location: 'Kandy Hills',
            severity: 'MED',
            color: ErisColors.riskMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage() {
    return _OnboardingContent(
      title: 'STAY SAFE',
      subtitle: 'PRECISE LOCATION',
      description: 'We need your location to send you alerts specific to your area and show the nearest shelters.',
      icon: Icons.location_on_rounded,
      iconColor: ErisColors.primary,
      extra: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ErisColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.gps_fixed_rounded, color: ErisColors.primary),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('Allow Location Access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Switch(value: true, onChanged: (v) {}, activeColor: ErisColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Widget? extra;

  const _OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 80, color: iconColor),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: iconColor, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white54, height: 1.5),
          ),
          if (extra != null) extra!,
        ],
      ),
    );
  }
}

class _AlertPreviewCard extends StatelessWidget {
  final String title;
  final String location;
  final String severity;
  final Color color;

  const _AlertPreviewCard({
    required this.title,
    required this.location,
    required this.severity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(severity, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
