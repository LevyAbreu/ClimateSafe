// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:climatesafe_app/pages/settings.dart';
import 'package:climatesafe_app/pages/top_inf.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:climatesafe_app/services/api_services.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final ApiService _apiService = ApiService();
  int _userId = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId') ?? 0;
      _nameController.text = prefs.getString('userName') ?? '';
      _loginController.text = prefs.getString('userLogin') ?? '';
      _emailController.text = prefs.getString('userEmail') ?? '';
    });
  }

  Future<void> _saveChanges() async {
    bool success = await _apiService.updateUserData(
      _userId,
      _nameController.text,
      _loginController.text,
      _emailController.text,
      _passwordController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    if (success) {
      prefs.setString('userName', _nameController.text);
      prefs.setString('userLogin', _loginController.text);
      prefs.setString('userEmail', _emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dados atualizados com sucesso!',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao atualizar dados. Tente novamente.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double topHeight = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: width, height: topHeight, child: const TopBar()),
            const SizedBox(height: 16),
            _buildEditableField('Nome', _nameController),
            _buildEditableField('Login', _loginController),
            _buildEditableField('Email', _emailController),
            _buildEditableField('Senha', _passwordController),
            const SizedBox(height: 20),
            IconButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _saveChanges();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              icon: Text(
                'Salvar Alterações',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onSurface,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}
