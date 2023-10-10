import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omega_chat/firebase_options.dart';
import 'package:omega_chat/screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omega Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 125, 141)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
