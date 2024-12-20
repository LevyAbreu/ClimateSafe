// ignore_for_file: library_private_types_in_public_api

import 'package:climatesafe_app/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:climatesafe_app/pages/top_inf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDarkMode = false;
  String _username = 'userName';
  String _email = 'userEmail';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('userName') ?? 'Deslogado';
      _email = prefs.getString('userEmail') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: width, height: topHeight, child: const TopBar()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueGrey,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _email,
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: _buildOption(context, Icons.person_outline, "Conta"),
            onPressed: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          IconButton(
            icon:
                _buildOption(context, Icons.settings_outlined, "Preferências"),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
          IconButton(
            icon: _buildOption(context, Icons.help_outline, "Ajuda"),
            onPressed: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          _buildDarkModeOption(),
          const Expanded(child: SizedBox()),
          _buildLogOut(),
        ],
      ),
    );
  }

  Widget _buildDarkModeOption() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Icon(
                  Icons.dark_mode_outlined,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                "Modo Escuro",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
              const Expanded(child: SizedBox()),
              Theme(
                data: ThemeData(
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    trackColor: WidgetStateProperty.all(Colors.grey.shade300),
                  ),
                ),
                child: Switch(
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });

                    if (_isDarkMode) {
                      ThemeMode.dark;
                    } else {
                      ThemeMode.light;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildLogOut() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              icon: Row(
                children: [
                  Text(
                    "Sair",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
