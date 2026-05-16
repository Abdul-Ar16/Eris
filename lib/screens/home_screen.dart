import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';
import '../services/ml_prediction_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  MlPrediction? _prediction;
  bool _isLoading = true;
  Timer? _refreshTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const location = 'Colombo, Western Province';

  @override
  void initState() {
    super.initState();

    // Pulse animation for the status badge
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fetchPrediction();
    // Auto-refresh every 10 seconds (MATLAB publishes every 5 s, so 10 s is safe)
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchPrediction(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchPrediction() async {
    final p = await MlPredictionService.getLatest();
    if (mounted) {
      setState(() {
        _prediction = p;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 80,
            backgroundColor: ErisColors.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                'DASHBOARD',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),
            actions: [
              // Live indicator dot
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: ScaleTransition(
                    scale: _pulseAnim,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _prediction == null
                            ? Colors.grey
                            : (_prediction!.isDisaster ? ErisColors.danger : Colors.greenAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLocationCard(location),
                const SizedBox(height: 24),

                // ── Section header ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Risks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_prediction != null)
                      Text(
                        'ML · ${_prediction!.confidencePct.toStringAsFixed(0)}% confident',
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Live risk cards (from ML model) ──────────────────
                if (_isLoading)
                  const _LoadingRiskCard()
                else if (_prediction == null)
                  const _OfflineRiskCard()
                else ...[
                  _LiveRiskCard(
                    title: 'Flood Risk',
                    level: _prediction!.floodRisk.toUpperCase(),
                    color: _riskColor(_prediction!.floodRisk),
                    icon: Icons.water_drop_rounded,
                    detail: 'Depth: ${_prediction!.floodDepthCm.toStringAsFixed(1)} cm  ·  '
                        'Flow: ${_prediction!.flowRateLpm.toStringAsFixed(1)} L/min',
                  ),
                  const SizedBox(height: 16),
                  _LiveRiskCard(
                    title: 'Landslide Risk',
                    level: _prediction!.landslideRisk.toUpperCase(),
                    color: _riskColor(_prediction!.landslideRisk),
                    icon: Icons.landscape_rounded,
                    detail: 'Soil: ${_prediction!.soilMoistPct.toStringAsFixed(0)}%  ·  '
                        'Tilt: ${_prediction!.tiltMaxDeg.toStringAsFixed(1)}°  ·  '
                        'Vib: ${_prediction!.vibration == 1 ? "YES" : "No"}',
                  ),
                  const SizedBox(height: 16),

                  // ── Overall ML verdict banner ─────────────────────
                  _MlVerdictBanner(prediction: _prediction!),
                ],

                const SizedBox(height: 32),

                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/evacuation'),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('View Evacuation Route'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/sos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.danger,
                    shadowColor: ErisColors.danger.withOpacity(0.4),
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('SOS EMERGENCY'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await NotificationService().showNotification(
                      title: 'Evacuation Warning',
                      body: 'Your area is under danger and evacuation is needed.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ErisColors.primary,
                  ),
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('TEST NOTIFICATION'),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':   return ErisColors.riskHigh;
      case 'medium': return ErisColors.riskMedium;
      default:       return ErisColors.riskSafe;
    }
  }

  Widget _buildLocationCard(String location) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ErisColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: ErisColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live risk card — shows real data from the ML model
// ─────────────────────────────────────────────────────────────────────────────

class _LiveRiskCard extends StatelessWidget {
  final String title;
  final String level;
  final Color color;
  final IconData icon;
  final String detail;

  const _LiveRiskCard({
    required this.title,
    required this.level,
    required this.color,
    required this.icon,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              detail,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overall ML verdict banner (DISASTER / SAFE)
// ─────────────────────────────────────────────────────────────────────────────

class _MlVerdictBanner extends StatelessWidget {
  final MlPrediction prediction;
  const _MlVerdictBanner({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final isDisaster = prediction.isDisaster;
    final color = isDisaster ? ErisColors.danger : Colors.green.shade700;
    final icon = isDisaster ? Icons.warning_amber_rounded : Icons.check_circle_rounded;
    final label = isDisaster ? '⚠  DISASTER RISK DETECTED' : '✓  CONDITIONS ARE SAFE';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Random Forest · ${prediction.confidencePct.toStringAsFixed(1)}% confidence · ${prediction.district}',
                  style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder cards when data is loading / backend offline
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingRiskCard extends StatelessWidget {
  const _LoadingRiskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _OfflineRiskCard extends StatelessWidget {
  const _OfflineRiskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ErisColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        children: [
          Icon(Icons.sensors_off, color: Colors.white38, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No ML Data Yet',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  'Start MATLAB + Python bridge to stream live predictions.',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
