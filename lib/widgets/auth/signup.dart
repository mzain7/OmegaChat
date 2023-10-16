import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omega_chat/screens/new_user.dart';
import 'package:omega_chat/utils/firebase.dart';
import 'package:omega_chat/utils/styles.dart';

final _auth = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.toggleAuthScreen});

  final void Function() toggleAuthScreen;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, String> userDetails = await Navigator.of(context).push(
          createRoute(true),
        );
        if (userDetails.isEmpty) {
          return;
        }
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        final photoUrl = await uploadImageToFirebase(userDetails['photoUrl']!);
        await userCredential.user?.updateDisplayName(userDetails['name']!);
        await userCredential.user?.updatePhotoURL(photoUrl);
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text,
          'name': userDetails['name'],
          'photoUrl': userDetails['photoUrl'],
          'gender': userDetails['gender'],
          'dob': userDetails['dob'],
          'country': userDetails['country'],
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color.fromARGB(117, 46, 46, 48),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10.0),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autovalidateMode: _autovalidateMode,
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
                const SizedBox(height: 10.0),
                TextFormField(
                  autovalidateMode: _autovalidateMode,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  decoration: textFieldStyle.copyWith(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  autovalidateMode: _autovalidateMode,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.toString().trim().isEmpty ||
                        value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: textFieldStyle.copyWith(
                    labelText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 244, 161, 31),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 12.0),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleAuthScreen();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
