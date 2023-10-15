import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [

          Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
          Text(FirebaseAuth.instance.currentUser!.email.toString()),
          Image.network(FirebaseAuth.instance.currentUser!.photoURL.toString()),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.sendSignInLinkToEmail(
                email: FirebaseAuth.instance.currentUser!.email.toString(),
                actionCodeSettings: ActionCodeSettings(
                  url:
                      'https://www.example.com/?email=${FirebaseAuth.instance.currentUser!.email.toString()}',
                  androidPackageName: 'com.example.omega_chat',
                  androidInstallApp: true,
                  androidMinimumVersion: '12',
                  handleCodeInApp: true,
                  iOSBundleId: 'com.example.omegaChat',
                  dynamicLinkDomain: 'example.page.link',
                  // iOSBundleId: 'com.example.omega_chat',
                  // dynamicLinkDomain: 'example.page.link',
                ),
              );
            },
            child: const Text('Sign in Email'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.sendPasswordResetEmail(
                  email: FirebaseAuth.instance.currentUser!.email.toString());
            },
            child: const Text('Password Reset'),
          ),
          ElevatedButton(
            onPressed: () async {
              print(FirebaseAuth.instance.currentUser);
            },
            child: const Text('print'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (phoneAuthCredential) {
                  print(phoneAuthCredential);
                },
                verificationFailed: (error) {},
                codeSent: (verificationId, forceResendingToken) {},
                codeAutoRetrievalTimeout: (verificationId) {},
                phoneNumber: '+923174317202',
              );
            },
            child: const Text('phone'),
          ),
        ],
      ),
    );
  }
}
