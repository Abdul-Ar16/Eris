import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model class matching the MlPrediction entity fields from Spring Boot
// ─────────────────────────────────────────────────────────────────────────────

class MlPrediction {
  final int id;
  final String district;
  final String predictionResult; // "DISASTER" or "SAFE"
  final double confidencePct;
  final String landslideRisk;    // Low / Medium / High
  final String floodRisk;        // Low / Medium / High
  final double soilMoistPct;
  final double tiltMaxDeg;
  final int vibration;
  final double floodDepthCm;
  final double flowRateLpm;
  final String receivedAt;

  MlPrediction({
    required this.id,
    required this.district,
    required this.predictionResult,
    required this.confidencePct,
    required this.landslideRisk,
    required this.floodRisk,
    required this.soilMoistPct,
    required this.tiltMaxDeg,
    required this.vibration,
    required this.floodDepthCm,
    required this.flowRateLpm,
    required this.receivedAt,
  });

  bool get isDisaster => predictionResult == 'DISASTER';

  factory MlPrediction.fromJson(Map<String, dynamic> json) {
    return MlPrediction(
      id:               json['id'] ?? 0,
      district:         json['district'] ?? 'Unknown',
      predictionResult: json['predictionResult'] ?? 'SAFE',
      confidencePct:    (json['confidencePct'] ?? 0).toDouble(),
      landslideRisk:    json['landslideRisk'] ?? 'Low',
      floodRisk:        json['floodRisk'] ?? 'Low',
      soilMoistPct:     (json['soilMoistPct'] ?? 0).toDouble(),
      tiltMaxDeg:       (json['tiltMaxDeg'] ?? 0).toDouble(),
      vibration:        json['vibration'] ?? 0,
      floodDepthCm:     (json['floodDepthCm'] ?? 0).toDouble(),
      flowRateLpm:      (json['flowRateLpm'] ?? 0).toDouble(),
      receivedAt:       json['receivedAt'] ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service — wraps all /api/ml endpoints
// ─────────────────────────────────────────────────────────────────────────────

class MlPredictionService {
  static final String _base = ApiConstants.baseUrl;

  /// GET /api/ml/prediction/latest
  /// Returns the single most recent Random Forest prediction.
  /// Returns null if no prediction has been stored yet.
  static Future<MlPrediction?> getLatest() async {
    try {
      final res = await http
          .get(Uri.parse('$_base${ApiConstants.mlPredictionLatestEndpoint}'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        print("-----------");
        print(res.body);
        return MlPrediction.fromJson(jsonDecode(res.body));
      }
    } catch (e) {
      print("-----------");
      print(e.toString());    }
    return null;
  }

  /// GET /api/ml/prediction/history
  /// Returns all predictions ordered newest first.
  static Future<List<MlPrediction>> getHistory() async {
    try {
      final res = await http
          .get(Uri.parse('$_base${ApiConstants.mlPredictionHistoryEndpoint}'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.map((e) => MlPrediction.fromJson(e)).toList();
      }
    } catch (e) {
      // ignore
    }
    return [];
  }
}
