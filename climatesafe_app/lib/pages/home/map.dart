// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climatesafe_app/services/api_services.dart';

class Alert {
  final LatLng location;
  final String type;
  final double radius;

  Alert({required this.location, required this.type, required this.radius});
}

class AlertNode {
  final Alert alert;
  AlertNode? next;

  AlertNode({required this.alert, this.next});
}

class Maps extends StatefulWidget {
  const Maps({super.key, required List<Map<String, dynamic>> alerts});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  LatLng? _currentLocation;
  AlertNode? _alertListHead;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadAlertsFromDatabase();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização desativado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização permanentemente negada.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _loadAlertsFromDatabase() async {
    try {
      final alertData = await _apiService.getAllAlerts();
      AlertNode? currentNode;

      for (var alert in alertData) {
        final locationParts = alert['location'].split(',');
        final latitude = double.parse(locationParts[0]);
        final longitude = double.parse(locationParts[1]);

        final newAlertNode = AlertNode(
          alert: Alert(
            location: LatLng(latitude, longitude),
            type: alert['type'],
            radius: 100.0,
          ),
        );

        if (_alertListHead == null) {
          _alertListHead = newAlertNode;
        } else {
          currentNode?.next = newAlertNode;
        }
        currentNode = newAlertNode;
      }
      setState(() {});
    } catch (e) {
      print("Erro ao carregar alertas: $e");
    }
  }

  List<CircleMarker> _buildAlertMarkers() {
    List<CircleMarker> markers = [];
    AlertNode? currentNode = _alertListHead;

    while (currentNode != null) {
      final alert = currentNode.alert;

      Color fillColor;
      Color borderColor;

      if (alert.type == "Alagamento") {
        fillColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
        borderColor = Colors.blue;
      } else if (alert.type == "Emergência") {
        fillColor = Colors.purple.withOpacity(0.3);
        borderColor = Colors.purple;
      } else {
        fillColor = Theme.of(context).colorScheme.secondary.withOpacity(0.3);
        borderColor = Colors.orange;
      }

      markers.add(
        CircleMarker(
          point: alert.location,
          radius: alert.radius,
          color: fillColor,
          borderStrokeWidth: 3,
          borderColor: borderColor,
        ),
      );

      currentNode = currentNode.next;
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: _currentLocation,
                zoom: 18.0,
                interactiveFlags:
                    InteractiveFlag.all & ~InteractiveFlag.doubleTapZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentLocation!,
                      radius: 10,
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 3,
                      borderColor: Colors.blue,
                    ),
                    ..._buildAlertMarkers(),
                  ],
                ),
              ],
            ),
    );
  }
}
