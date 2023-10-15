import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
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
                FirebaseAuth.instance.currentUser?.sendEmailVerification();
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
                // var data = FirebaseAuth.instance.currentUser?.providerData.removeLast();
                // Map<String, dynamic> x = jsonDecode(jsonEncode(data));
                // FirebaseAuth.instance.currentUser?.providerData.add(UserInfo.fromJson({...x, 'country': 'Pakistan'}));
                // UserInfo
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
      ),
    );
  }
}