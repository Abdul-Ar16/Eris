import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(color: Colors.white24),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildFirstPage(),
                  _buildSecondPage(),
                  _buildThirdPage(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildPageIndicator(),
            const SizedBox(height: 30),
            _buildNextButton(),
            const SizedBox(height: 15),
            if (_currentPage == 0)
              const Text(
                'Already have an account? Log in',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF3E190B),
              shape: BoxShape.circle,
            ),
            child: const Text('🚨', style: TextStyle(fontSize: 60)),
          ),
          const SizedBox(height: 60),
          const Text(
            'DISASTER ALERT',
            style: TextStyle(
              color: Color(0xFFD9B067),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'EARLY WARNING SYSTEM',
            style: TextStyle(
              color: Color(0xFFBC6C33),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Stay ahead of floods and landslides. Get real-time alerts, evacuation routes, and safety guidance — right on your phone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF232D3F),
              shape: BoxShape.circle,
            ),
            child: const Text('🔔', style: TextStyle(fontSize: 60)),
          ),
          const SizedBox(height: 60),
          const Text(
            'REAL-TIME ALERTS',
            style: TextStyle(
              color: Color(0xFFD9B067),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              decorationThickness: 2,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'The moment our sensors detect rising water levels or unstable soil conditions, you’ll be the first to know - even before it happens',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          _buildAlertCard(
            '🌊',
            'Flood risk detected - Colombo 05',
            'HIGH',
            const Color(0xFF3E190B),
            const Color(0xFFB13131),
          ),
          const SizedBox(height: 15),
          _buildAlertCard(
            '⛰️',
            'Landslide warning - Kandy Hills',
            'MED',
            const Color(0xFF342A1E),
            const Color(0xFFBC6C33),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String emoji, String text, String tag, Color bgColor, Color tagTextColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: tagTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2E20),
              shape: BoxShape.circle,
            ),
            child: const Text('📍', style: TextStyle(fontSize: 60)),
          ),
          const SizedBox(height: 60),
          const Text(
            'ENABLE LOCATION',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'We need your location to send you alerts that are specific to your area and show you the nearest evacuation shelters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSwitchRow('📍', 'Allow Location Access'),
                const Divider(color: Colors.white24, height: 1),
                _buildSwitchRow('🔔', 'Allow Location Access'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Switch(
            value: true,
            onChanged: (v) {},
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFBC6C33),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 40 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: _currentPage == index ? const Color(0xFFBC6C33) : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    String text = 'GET STARTED →';
    if (_currentPage == 1) text = 'NEXT →';
    if (_currentPage == 2) text = 'ALLOW & CONTINUE';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: () {
          if (_currentPage < 2) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFBC6C33),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_currentPage == 2) ...[
                const SizedBox(height: 8),
                const Text(
                  '✓',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
