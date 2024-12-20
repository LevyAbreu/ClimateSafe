import 'package:climatesafe_app/pages/settings/account.dart';
import 'package:climatesafe_app/pages/settings/config.dart';
import 'package:climatesafe_app/pages/settings/help.dart';
import 'package:flutter/material.dart';
import 'package:climatesafe_app/pages/auth/login.dart';
import 'package:climatesafe_app/pages/auth/signup.dart';
import 'package:climatesafe_app/pages/chat.dart';
import 'package:climatesafe_app/pages/home/home.dart';
import 'package:climatesafe_app/pages/settings.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => Login(),
      '/login': (context) => Login(),
      '/signup': (context) => SignUp(),
      '/home': (context) => const Home(),
      '/chat': (context) => const Chat(),
      '/settings': (context) => const Settings(),
      '/account': (context) => const Account(),
      '/config': (context) => const Config(),
      '/help': (context) => const Help(),
    };
  }
}
