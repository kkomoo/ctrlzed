import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true; // Toggles between Login & Register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLogin
          ? LoginScreen(onSwitch: () => setState(() => isLogin = false))
          : RegisterScreen(onSwitch: () => setState(() => isLogin = true)),
    );
  }
}
