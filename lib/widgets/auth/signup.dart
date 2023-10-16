import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omega_chat/screens/home_screen.dart';
import 'package:omega_chat/screens/new_user.dart';
import 'package:omega_chat/utils/firebase.dart';
import 'package:omega_chat/widgets/auth/login_credential.dart';

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
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // var userExist = false;
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // print('start');
        // userExist =
        //     (await _auth.fetchSignInMethodsForEmail(_emailController.text))
        //         .isNotEmpty;
        // print(userExist);
        // if (userExist) {
        //   throw Exception('User already exists');
        // }
        Map<String, String> userDetails = await Navigator.of(context).push(
          createRoute(true),
        );
        if (userDetails.isEmpty) {
          return;
        }
        print('Back to Sign up Screen');
        print(userDetails);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        print(userCredential.user);
        // userCredential.user?.sendEmailVerification();

        final photoUrl = await uploadImageToFirebase(userDetails['photoUrl']!);
        print('Url of PHOTO IS   NCOECECNIWCN :  ::::::::::::::' + photoUrl);
        await userCredential.user?.updateDisplayName(userDetails['name']!);
        await userCredential.user?.updatePhotoURL(photoUrl);

        print(userCredential.user);
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),));

        // Store additional information (gender, age) in Firestore
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

        // Navigate to the next screen or perform desired action
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          // TextFormField(
          //   controller: _usernameController,
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return 'Please enter a username';
          //     }
          //     return null;
          //   },
          //   decoration: const InputDecoration(labelText: 'Username'),
          // ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Confirm Password'),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
