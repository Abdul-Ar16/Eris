import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('REAL-TIME MONITOR'),
          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ErisColors.primary.withOpacity(0.1),
            ),
            dividerColor: Colors.transparent,
            labelColor: ErisColors.primary,
            unselectedLabelColor: Colors.white38,
            tabs: const [
              Tab(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.water_drop_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('FLOOD'),
                  ],
                ),
              ),
              Tab(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.landscape_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('LANDSLIDE'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FloodMonitoringView(),
            _LandslideMonitoringView(),
          ],
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RiskSummaryCard(
            label: 'CURRENT RISK LEVEL',
            levelText: 'HIGH RISK',
            levelColor: ErisColors.riskHigh,
            description: 'Intense rainfall expected in the next 3 hours.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Environmental Metrics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const _MetricGrid(
            metrics: [
              _MetricItem(label: 'Wind Speed', value: '45 km/h', progress: 0.78, icon: Icons.air_rounded),
              _MetricItem(label: 'Rainfall', value: '28 mm', progress: 0.62, icon: Icons.umbrella_rounded),
              _MetricItem(label: 'Pressure', value: '1008 hPa', progress: 0.42, icon: Icons.compress_rounded),
              _MetricItem(label: 'Humidity', value: '82%', progress: 0.68, icon: Icons.water_rounded),
            ],
          ),
          const SizedBox(height: 32),
          const _SafetyInstructions(
            title: 'IMMEDIATE ACTIONS',
            bullets: [
              'Move valuable items to higher ground',
              'Disconnect all electrical appliances',
              'Ensure your emergency kit is accessible',
              'Stay tuned to local news for evacuation orders',
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RiskSummaryCard(
            label: 'CURRENT RISK LEVEL',
            levelText: 'MODERATE',
            levelColor: ErisColors.riskMedium,
            description: 'Soil saturation levels are increasing. Stay alert.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Environmental Metrics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const _MetricGrid(
            metrics: [
              _MetricItem(label: 'Soil Moisture', value: '64%', progress: 0.64, icon: Icons.opacity_rounded),
              _MetricItem(label: 'Slope Angle', value: '32°', progress: 0.4, icon: Icons.architecture_rounded),
              _MetricItem(label: 'Ground Vib.', value: '2.4 Hz', progress: 0.35, icon: Icons.vibration_rounded),
              _MetricItem(label: 'Recent Rain', value: '12 mm', progress: 0.48, icon: Icons.cloud_outlined),
            ],
          ),
          const SizedBox(height: 32),
          const _SafetyInstructions(
            title: 'SAFETY PROTOCOLS',
            bullets: [
              'Monitor for new cracks in building foundations',
              'Avoid driving near steep mountain slopes',
              'Watch for sudden water level changes in streams',
              'Identify multiple evacuation routes',
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
  final String description;

  const _RiskSummaryCard({
    required this.label,
    required this.levelText,
    required this.levelColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              Icon(Icons.shield_rounded, color: levelColor.withOpacity(0.5), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            levelText,
            style: TextStyle(color: levelColor, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final List<_MetricItem> metrics;

  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: metrics,
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final IconData icon;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ErisColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: ErisColors.primary),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: ErisColors.primary,
              minHeight: 4,
            ),
          ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ErisColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ErisColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: ErisColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.check_circle_rounded, size: 14, color: ErisColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
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
