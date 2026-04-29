import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/evacuation_service.dart';
import '../theme/app_theme.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();
  final EvacuationService _evacuationService = EvacuationService();
  static const LatLng _fallbackCenter = LatLng(6.9271, 79.8612);

  LatLng _userLocation = _fallbackCenter;
  List<ShelterLocation> _shelters = [];
  ShelterLocation? _selectedShelter;
  List<LatLng> _routePoints = [];
  StreamSubscription<Position>? _positionSubscription;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _shelters = _evacuationService.getShelters(district: 'Colombo');
    if (_shelters.isNotEmpty) {
      _selectedShelter = _shelters.first;
      _rebuildRoute();
    }
    _startLiveTracking();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Map<String, dynamic>) {
      final shelterId = routeArgs['shelterId']?.toString();
      if (shelterId != null) {
        final selected = _evacuationService.getShelterById(shelterId);
        if (selected != null && selected.id != _selectedShelter?.id) {
          setState(() {
            _selectedShelter = selected;
            _rebuildRoute();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLiveTracking() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final current = await Geolocator.getCurrentPosition();
    if (!mounted) return;

    setState(() {
      _userLocation = LatLng(current.latitude, current.longitude);
      _rebuildRoute();
    });

    _mapController.move(_userLocation, 14.0);

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
      ),
    ).listen((position) {
      if (!mounted) return;
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _rebuildRoute();
      });
      if (_isNavigating) {
        _mapController.move(_userLocation, _mapController.camera.zoom);
      }
    });
  }

  void _rebuildRoute() {
    final shelter = _selectedShelter;
    if (shelter == null) {
      _routePoints = [];
      return;
    }
    _routePoints = _evacuationService.buildNavigationRoute(
      from: _userLocation,
      to: shelter,
    );
  }

  void _selectShelter(ShelterLocation shelter) {
    setState(() {
      _selectedShelter = shelter;
      _rebuildRoute();
    });
    _mapController.move(LatLng(shelter.latitude, shelter.longitude), 14.8);
  }

  @override
  Widget build(BuildContext context) {
    final selectedShelter = _selectedShelter;
    final distanceLabel = selectedShelter == null
        ? '--'
        : selectedShelter.distanceFrom(_userLocation);
    final durationLabel = selectedShelter?.time ?? '--';

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.eris',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: ErisColors.primary,
                      size: 30,
                    ),
                  ),
                  ..._shelters.map(
                    (shelter) => Marker(
                      point: LatLng(shelter.latitude, shelter.longitude),
                      width: 44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () => _selectShelter(shelter),
                        child: Icon(
                          Icons.home_rounded,
                          color: shelter.id == selectedShelter?.id
                              ? ErisColors.primary
                              : ErisColors.success,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_routePoints.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 5,
                      color: ErisColors.primary,
                    ),
                  ],
                ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(6.935, 79.855),
                    color: ErisColors.riskHigh.withOpacity(0.3),
                    borderStrokeWidth: 2,
                    borderColor: ErisColors.riskHigh,
                    useRadiusInMeter: true,
                    radius: 500,
                  ),
                ],
              ),
            ],
          ),

          // Top Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _MapActionButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: ErisColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            children: [
                              Icon(Icons.search_rounded, color: ErisColors.primary),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search for shelters or routes',
                                  style: TextStyle(color: Colors.white38, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(label: 'Shelters', icon: Icons.home_rounded, isSelected: true),
                        _FilterChip(label: 'Safe Zones', icon: Icons.shield_rounded),
                        _FilterChip(label: 'Flooded Roads', icon: Icons.water_drop_rounded),
                        _FilterChip(label: 'Medical', icon: Icons.medical_services_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Controls (Right Side)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                _MapActionButton(icon: Icons.layers_rounded, onPressed: () {}),
                const SizedBox(height: 12),
                _MapActionButton(
                  icon: Icons.my_location_rounded, 
                  onPressed: () {
                    _mapController.move(_userLocation, 14.0);
                  }
                ),
                const SizedBox(height: 12),
                _MapActionButton(
                  icon: Icons.zoom_in_rounded, 
                  onPressed: () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
                  }
                ),
                _MapActionButton(
                  icon: Icons.zoom_out_rounded, 
                  onPressed: () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
                  }
                ),
              ],
            ),
          ),

          // Bottom Info Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ErisColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ErisColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.navigation_rounded, color: ErisColors.success),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedShelter?.title ?? 'Select a Shelter',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '$distanceLabel • $durationLabel',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedShelter == null
                        ? null
                        : () {
                            setState(() {
                              _isNavigating = !_isNavigating;
                            });
                            if (_isNavigating) {
                              _mapController.move(_userLocation, 15.0);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ErisColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(_isNavigating ? 'STOP NAVIGATION' : 'START NAVIGATION'),
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

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: ErisColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _FilterChip({required this.label, required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? ErisColors.primary : ErisColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.white54),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
