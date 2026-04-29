import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ShelterLocation {
  final String id;
  final String title;
  final String type;
  final String capacity;
  final String time;
  final String status;
  final String district;
  final double latitude;
  final double longitude;
  final bool isSafeRoute;

  const ShelterLocation({
    required this.id,
    required this.title,
    required this.type,
    required this.capacity,
    required this.time,
    required this.status,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.isSafeRoute,
  });

  String distanceFrom(LatLng userLocation) {
    final meterDistance = const Distance().as(
      LengthUnit.Meter,
      userLocation,
      LatLng(latitude, longitude),
    );
    return '${(meterDistance / 1000).toStringAsFixed(1)} km';
  }
}

/// Service for fetching evacuation routes and safe zones from the backend.
class EvacuationService {
  static const List<ShelterLocation> _shelters = [
    ShelterLocation(
      id: 'narahenpita_high_school',
      title: 'Narahenpita High School',
      type: 'Primary Shelter',
      capacity: '450/500 available',
      time: '15 mins walk',
      status: 'SAFE ROUTE',
      district: 'Colombo',
      latitude: 6.9056,
      longitude: 79.8772,
      isSafeRoute: true,
    ),
    ShelterLocation(
      id: 'city_community_center',
      title: 'City Community Center',
      type: 'Emergency Shelter',
      capacity: '120/300 available',
      time: '8 mins drive',
      status: 'CONGESTED',
      district: 'Colombo',
      latitude: 6.9150,
      longitude: 79.8750,
      isSafeRoute: false,
    ),
    ShelterLocation(
      id: 'independence_memorial_hall',
      title: 'Independence Memorial Hall',
      type: 'Safe Zone',
      capacity: '620/800 available',
      time: '11 mins drive',
      status: 'SAFE ROUTE',
      district: 'Colombo',
      latitude: 6.9109,
      longitude: 79.8673,
      isSafeRoute: true,
    ),
    ShelterLocation(
      id: 'thurstan_college_hall',
      title: 'Thurstan College Hall',
      type: 'Primary Shelter',
      capacity: '280/400 available',
      time: '10 mins drive',
      status: 'SAFE ROUTE',
      district: 'Colombo',
      latitude: 6.9017,
      longitude: 79.8605,
      isSafeRoute: true,
    ),
    ShelterLocation(
      id: 'devi_balika_school',
      title: 'Devi Balika School Grounds',
      type: 'Secondary Shelter',
      capacity: '360/600 available',
      time: '17 mins walk',
      status: 'MODERATE TRAFFIC',
      district: 'Colombo',
      latitude: 6.9065,
      longitude: 79.8708,
      isSafeRoute: true,
    ),
    ShelterLocation(
      id: 'royal_college_complex',
      title: 'Royal College Sports Complex',
      type: 'Emergency Shelter',
      capacity: '510/700 available',
      time: '14 mins drive',
      status: 'SAFE ROUTE',
      district: 'Colombo',
      latitude: 6.9022,
      longitude: 79.8636,
      isSafeRoute: true,
    ),
  ];

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EVACUATION ROUTES
  // ═══════════════════════════════════════════════════════════════════════

  // ── Get all evacuation routes ───────────────────────────────────────────
  Future<List<dynamic>> getAllRoutes() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get evacuation routes by district ───────────────────────────────────
  Future<List<dynamic>> getRoutesByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/district/$district');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get routes by district and disaster type ────────────────────────────
  Future<List<dynamic>> getRoutesByDistrictAndType(
      String district, String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/district/$district/type/$type');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get route by ID ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getRouteById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.evacuationRoutesEndpoint}/$id');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SAFE ZONES
  // ═══════════════════════════════════════════════════════════════════════

  // ── Get all safe zones ──────────────────────────────────────────────────
  Future<List<dynamic>> getAllSafeZones() async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get safe zones by district ──────────────────────────────────────────
  Future<List<dynamic>> getSafeZonesByDistrict(String district) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/district/$district');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get safe zones by type ──────────────────────────────────────────────
  Future<List<dynamic>> getSafeZonesByType(String type) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/type/$type');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Get safe zone by ID ─────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getSafeZoneById(int id) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.safeZonesEndpoint}/$id');
      final headers = await _authHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<ShelterLocation> getShelters({String? district}) {
    final list = district == null
        ? _shelters
        : _shelters.where((shelter) => shelter.district == district).toList();
    return List<ShelterLocation>.from(list);
  }

  ShelterLocation? getShelterById(String id) {
    for (final shelter in _shelters) {
      if (shelter.id == id) return shelter;
    }
    return null;
  }

  List<ShelterLocation> getNearestShelters(LatLng userLocation, {int limit = 5}) {
    final sorted = List<ShelterLocation>.from(_shelters)
      ..sort((a, b) {
        final aDistance = const Distance().as(
          LengthUnit.Meter,
          userLocation,
          LatLng(a.latitude, a.longitude),
        );
        final bDistance = const Distance().as(
          LengthUnit.Meter,
          userLocation,
          LatLng(b.latitude, b.longitude),
        );
        return aDistance.compareTo(bDistance);
      });
    return sorted.take(limit).toList();
  }

  List<LatLng> buildNavigationRoute({
    required LatLng from,
    required ShelterLocation to,
  }) {
    const interpolationSteps = 14;
    final points = <LatLng>[from];

    for (var i = 1; i < interpolationSteps; i++) {
      final t = i / interpolationSteps;
      points.add(
        LatLng(
          from.latitude + ((to.latitude - from.latitude) * t),
          from.longitude + ((to.longitude - from.longitude) * t),
        ),
      );
    }

    points.add(LatLng(to.latitude, to.longitude));
    return points;
  }
}
