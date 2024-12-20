// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:climatesafe_app/pages/top_inf.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: width, height: topHeight, child: const TopBar()),
          IconButton(
            icon: _buildOption(context, Icons.link, "Redes Sociais"),
            onPressed: () async {
              const url =
                  'https://www.instagram.com/climate_safe?igsh=MWlkNWgya3N5ODk2eg==';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Não foi possível abrir o link')),
                );
              }
            },
          ),
          IconButton(
            icon: _buildOption(
                context, Icons.file_open_outlined, "Políticas de Privacidade"),
            onPressed: () async {
              const url = 'https://policies.google.com/privacy?hl=pt-BR';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Não foi possível abrir o link')),
                );
              }
            },
          ),
          IconButton(
            icon: _buildOption(context, Icons.info, "Sobre o App"),
            onPressed: () {
              // Sobre o APP
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
