import 'package:flutter/material.dart';
import 'package:omega_chat/widgets/login.dart';
import 'package:omega_chat/widgets/login_credential.dart';
import 'package:omega_chat/widgets/signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var newUser = true;

  void toggleAuthScreen() {
    setState(() {
      newUser = !newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 48, 125, 141),
              Color.fromARGB(255, 47, 54, 73),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
              ),
              const Text('OmegaChat'),
              Container(
                alignment: Alignment.center,
                child: newUser? Login(toggleAuthScreen: toggleAuthScreen) : SignUpScreen(toggleAuthScreen: toggleAuthScreen),
              ),
              LoginCredentials(),
            ],
          ),
        ),
      ),
    );
  }
}
