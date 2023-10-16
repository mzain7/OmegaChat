import 'package:flutter/material.dart';
import 'package:omega_chat/widgets/auth/login.dart';
import 'package:omega_chat/widgets/auth/login_credential.dart';
import 'package:omega_chat/widgets/auth/signup.dart';

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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color.fromARGB(255, 2, 0, 16),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg0.jpg'),
            fit: BoxFit.cover,
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Color.fromARGB(255, 48, 125, 141),
          //     Color.fromARGB(255, 47, 54, 73),
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                ),
                
              ),
              const SizedBox(height: 2),
              Container(
                alignment: Alignment.center,
                child: newUser
                    ? Login(toggleAuthScreen: toggleAuthScreen)
                    : SignUpScreen(toggleAuthScreen: toggleAuthScreen),
              ),
              const SizedBox(height: 8),
              const LoginCredentials(),
            ],
          ),
        ),
      ),
    );
  }
}
