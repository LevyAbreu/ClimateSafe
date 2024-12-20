// ignore_for_file: use_build_context_synchronously, unused_element, dead_code, library_private_types_in_public_api

import 'package:climatesafe_app/pages/home/map.dart';
import 'package:climatesafe_app/pages/top_inf.dart';
import 'package:climatesafe_app/services/api_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showAlert = false;
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    try {
      final allAlerts = await apiService.getAllAlerts();
      if (mounted) {
        setState(() {
          alerts = allAlerts;
        });
      }
    } catch (e) {
      _showFeedback(context, false, message: "Erro ao carregar alertas.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;
    double blockHeight = MediaQuery.of(context).size.height * 0.43;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(width: width, height: topHeight, child: const TopBar()),
              Expanded(child: Maps(alerts: alerts)),
            ],
          ),
          showAlert
              ? Positioned(
                  bottom: 0.0,
                  child: SizedBox(
                    height: blockHeight,
                    width: width,
                    child: AlertInfo(alerts: alerts),
                  ),
                )
              : Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      _showAlertMenu(context);
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.warning_amber_outlined,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
        ],
      ),
    );
  }

  void _showAlertMenu(BuildContext context) async {
    try {
      Position position = await _getCurrentLocation();

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.water,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    "Alagamento",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () async {
                    bool success = await apiService.createAlert(
                        "Alagamento",
                        "${position.latitude}, ${position.longitude}",
                        "imagem");
                    Navigator.pop(context);

                    if (success) {
                      await _loadAlerts();
                    }
                    _showFeedback(context, success);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_fire_department,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text(
                    "Queimada",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () async {
                    bool success = await apiService.createAlert(
                        "Queimada",
                        "${position.latitude}, ${position.longitude}",
                        "imagem");
                    Navigator.pop(context);
                    if (success) {
                      await _loadAlerts();
                    }
                    _showFeedback(context, success);
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _showFeedback(context, false, message: "Erro ao acessar localização.");
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showFeedback(context, false,
          message: "Serviço de localização desativado.");
      throw Exception('Serviço de localização desativado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showFeedback(context, false,
            message: "Permissão de localização negada.");
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showFeedback(context, false,
          message: "Permissão permanentemente negada.");
      throw Exception('Permissão permanentemente negada.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _showFeedback(BuildContext context, bool success, {String? message}) {
    final feedbackMessage = message ??
        (success ? "Alerta criado com sucesso!" : "Falha ao criar o alerta.");
    final color = success ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(feedbackMessage), backgroundColor: color),
    );
  }
}

class AlertInfo extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;

  const AlertInfo({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double imageWidth = 150;
    double imageHeight = 100;

    final alert = alerts.isNotEmpty ? alerts.last : null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 3,
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: imageHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: imageHeight,
                      width: imageWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (alert != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8),
              child: Row(
                children: [
                  Text(
                    alert['type'] ?? 'Tipo não encontrado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8),
              child: Row(
                children: [
                  Text(
                    'Localização: ${alert['location'] ?? 'Local não encontrado'}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: Container(
                    width: width * 0.2,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/details",
                            arguments: alert);
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}
