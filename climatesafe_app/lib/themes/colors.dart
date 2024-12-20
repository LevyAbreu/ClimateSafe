import 'package:climatesafe_app/routes/routes.dart';
import 'package:flutter/material.dart';

class ClimateSafeTheme extends StatelessWidget {
  const ClimateSafeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClimateSafe',
      theme: ThemeData(
        fontFamily: null,
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff1299f0),
          onPrimary: Color(0xffffffff),
          primaryContainer: Color(0xff1299f0),
          onPrimaryContainer: Color(0xff1299f0),
          secondary: Color(0xffffaf00),
          onSecondary: Color(0xff000000),
          secondaryContainer: Color(0xffC47313),
          onSecondaryContainer: Color(0xffffffff),
          surface: Color.fromARGB(255, 243, 243, 255),
          onSurface: Color(0xffffffff),
          error: Color(0xffb00020),
          onError: Color(0xffffffff),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: null,
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xff1875B0),
          onPrimary: Color(0xffffffff),
          primaryContainer: Color(0xff1299f0),
          onPrimaryContainer: Color(0xffffffff),
          secondary: Color(0xffffaf00),
          onSecondary: Color(0xffffffff),
          secondaryContainer: Color(0xffC47313),
          onSecondaryContainer: Color(0xff16202B),
          surface: Color(0xff16202B),
          onSurface: Color(0xff1C2939),
          error: Color(0xffcf6679),
          onError: Color(0xff000000),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: AppRoutes.getRoutes(),
    );
  }
}
