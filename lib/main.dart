import "features/onboarding/screens/get_started_screen.dart";
import "features/auth/screens/login_screen.dart";
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Runmate",
      routes: {
        '/': (context) => const GetStartedScreen(),
        '/login': (context) => const LoginScreen(),
      },
      initialRoute: '/',
    );
  }
}