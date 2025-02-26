import 'package:flutter/material.dart';
import 'auth.dart';

import 'login.dart';
import 'register.dart';
import 'profile.dart';
import 'settings.dart';
import 'homepage.dart';

import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ... other providers ...
      ],
      child: const MyApp(),
    ),
  );
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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthScreen(),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );

      },
    );
  }
}
