// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://172.16.58.183:5000";

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userData['id']);
    prefs.setString('userName', userData['name']);
    prefs.setString('userLogin', userData['login']);
    prefs.setString('userEmail', userData['email']);
  }

  Future<bool> verifyLogin(String login, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"login": login, "password": password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _saveUserData(data['user']);
          return true;
        } else {
          print('Login falhou: ${data['message']}');
        }
      } else {
        print('Erro HTTP no login: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante o login: $e');
    }
    return false;
  }

  Future<bool> registerUser(
      String name, String login, String email, String password) async {
    final url = Uri.parse('$baseUrl/user');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": name,
              "login": login,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Erro HTTP no registro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao registrar usuário: $e');
    }
    return false;
  }

  Future<bool> updateUserData(
      int id, String name, String login, String email, String password) async {
    final url = Uri.parse('$baseUrl/user/$id');
    try {
      final response = await http
          .put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": name,
              "login": login,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _saveUserData(
              {"id": id, "name": name, "login": login, "email": email});
          return true;
        }
      } else {
        print('Erro HTTP na atualização: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao atualizar dados do usuário: $e');
    }
    return false;
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    String userName = prefs.getString('userName') ?? '';
    String userLogin = prefs.getString('userLogin') ?? '';
    String userEmail = prefs.getString('userEmail') ?? '';

    return {
      'id': userId,
      'name': userName,
      'login': userLogin,
      'email': userEmail
    };
  }

  // CHAT
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final url = Uri.parse('$baseUrl/messages');
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json"
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['messages'] != null) {
          return List<Map<String, dynamic>>.from(data['messages']);
        }
      } else {
        print('Erro HTTP ao buscar mensagens: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar mensagens: $e');
    }
    return [];
  }

  Future<bool> createMessage(String message, String username) async {
    if (message.trim().isEmpty || username.trim().isEmpty) return false;

    final url = Uri.parse('$baseUrl/chat');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"message": message, "username": username}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Erro HTTP ao criar mensagem: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao criar mensagem: $e');
    }
    return false;
  }

  // ALERTS
  Future<bool> createAlert(String type, String loc, String image) async {
    final url = Uri.parse('$baseUrl/alert');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "type": type,
              "location": loc,
              "image": image,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Erro HTTP ao criar alerta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao criar alerta: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getAllAlerts() async {
    final url = Uri.parse('$baseUrl/alerts');
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json"
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['alerts'] != null) {
          return List<Map<String, dynamic>>.from(data['alerts']);
        }
      } else {
        print('Erro HTTP ao buscar alertas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar alertas: $e');
    }
    return [];
  }
}
