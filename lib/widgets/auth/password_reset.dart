import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omega_chat/utils/styles.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key, required this.email});

  final String email;
  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  var success = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        setState(() {
          success = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 60, 55, 76),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text(
        'Reset Password!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: !success
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: textFieldStyle.copyWith(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        onPressed: () {
                          _resetPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
            )
          : Image.asset(
              'assets/images/success.gif',
              height: MediaQuery.of(context).size.height / 6,
            ),
    );
  }
}
