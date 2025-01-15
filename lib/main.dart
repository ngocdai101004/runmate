import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:provider/provider.dart";
import "fake_data_generator.dart";
import "features/let_run/screens/run_screen.dart";
import "features/onboarding/screens/get_started_screen.dart";
import "features/auth/screens/login_screen.dart";
import "features/auth/screens/register_screen.dart";
import "features/profile/screens/profile_screen.dart";
import "common/providers/user_provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final generator = FakeDataGenerator();
  await generator.generateFakeData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Runmate",
        routes: {
          '/': (context) => const GetStartedScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const ProfileScreen(),
          '/let_run': (context) => const RunScreen(),
      },
        initialRoute: '/let_run',
      ),
    );
  }
}