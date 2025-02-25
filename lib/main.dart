import 'package:flutter/material.dart';
import 'auth.dart';
import 'login.dart';
import 'register.dart';
import 'profile.dart';
import 'settings.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
      routes: {
        '/login': (context) => LoginScreen(onSwitch: () {}),
        '/register': (context) => RegisterScreen(onSwitch: () {}),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
