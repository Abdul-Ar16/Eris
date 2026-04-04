// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ErisColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  children: [
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.arrow_back, color: Colors.white54),
                    // ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'MONITOR',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const TabBar(
                padding: EdgeInsets.symmetric(horizontal: 18),
                tabs: [
                  Tab(
                    icon: Icon(Icons.water_drop_outlined),
                    child: Text('FLOOD'),
                  ),
                  Tab(
                    icon: Icon(Icons.terrain_outlined),
                    child: Text('LANDSLIDE'),
                  ),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorColor: ErisColors.primary,
              ),
              const SizedBox(height: 14),
              const Expanded(
                child: TabBarView(
                  children: [
                    _FloodMonitoringView(),
                    _LandslideMonitoringView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloodMonitoringView extends StatelessWidget {
  const _FloodMonitoringView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RiskSummaryCard(
            label: 'CURRENT RISK LEVEL',
            levelText: 'High',
            levelColor: ErisColors.riskHigh,
          ),
          const SizedBox(height: 14),
          _MetricBar(
            label: 'Wind Speed',
            valueText: '45 km/h',
            progress: 0.78,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Rainfall',
            valueText: '28 mm',
            progress: 0.62,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Rainfall',
            valueText: '1008 hPa',
            progress: 0.42,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Humidity',
            valueText: '82%',
            progress: 0.68,
          ),
          const SizedBox(height: 18),
          const _SafetyInstructions(
            title: 'SAFETY INSTRUCTIONS',
            bullets: [
              'Secure loose items',
              'Close windows and doors',
              'Stay indoors',
              'Keep emergency kit ready',
            ],
          ),
        ],
      ),
    );
  }
}

class _LandslideMonitoringView extends StatelessWidget {
  const _LandslideMonitoringView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RiskSummaryCard(
            label: 'CURRENT RISK LEVEL',
            levelText: 'Medium',
            levelColor: ErisColors.riskMedium,
          ),
          const SizedBox(height: 14),
          _MetricBar(
            label: 'Soil Moisture',
            valueText: '45 km/h',
            progress: 0.54,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Slope Angle',
            valueText: '30°',
            progress: 0.4,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Rainfall',
            valueText: '28 mm',
            progress: 0.48,
          ),
          const SizedBox(height: 10),
          _MetricBar(
            label: 'Seismic Activity',
            valueText: '2.0',
            progress: 0.22,
          ),
          const SizedBox(height: 18),
          const _SafetyInstructions(
            title: 'SAFETY INSTRUCTIONS',
            bullets: [
              'Evacuate if advised',
              'Avoid steep slopes and unstable ground',
              'Stay alert and listen to local authorities',
              'Keep emergency kit ready',
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  final String label;
  final String levelText;
  final Color levelColor;

  const _RiskSummaryCard({
    required this.label,
    required this.levelText,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              levelText,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  final String label;
  final String valueText;
  final double progress; // 0..1

  const _MetricBar({
    required this.label,
    required this.valueText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white12,
            color: ErisColors.primary,
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(valueText, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SafetyInstructions extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const _SafetyInstructions({
    required this.title,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_outline, size: 16, color: Colors.white54),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

