import 'package:climatesafe_app/pages/top_inf.dart';
import 'package:flutter/material.dart';

class Config extends StatelessWidget {
  const Config({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: width, height: topHeight, child: const TopBar()),
          // Conta
          IconButton(
            icon: _buildOption(context, Icons.person_outline, "Idioma do app"),
            onPressed: () {
              // Idioma
            },
          ),

          // Ajustes
          IconButton(
            icon: _buildOption(
                context, Icons.settings_outlined, "Tamanho da fonte"),
            onPressed: () {
              // Ajustes
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
