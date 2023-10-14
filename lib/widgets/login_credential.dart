import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omega_chat/screens/home_screen.dart';

class LoginCredentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  LoginCredentials({super.key});

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
      // UserCredential? userCredential =
      //     await _auth.signInWithCredential(credential);
      // bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // if (isNewUser) {
      //   String? dateOfBirth = googleUser.id;
      //   String? profilePicture = googleUser.photoUrl;

      //   // Store the user data in Firestore
      //   // await storeUserData(userCredential.user, dateOfBirth, profilePicture);
      //       }
    } catch (error) {
      print(error);
      // ScaffoldMessenger.of(context).clearSnackBars();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Authentication failed. Please try again. $error'),
      //   ),
      // );
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    // Trigger the sign-in flow
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      final user = await FacebookAuth.instance.getUserData();
      print(user);
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (error) {
      print(error);
      // ScaffoldMessenger.of(context).clearSnackBars();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Authentication failed. Please try again. $error'),
      //   ),
      // );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          onPressed: () async {
            UserCredential? userCredential = await signInWithGoogle();
            if (userCredential != null) {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),));

              print(
                  "Google User Logged In: ${userCredential.user?.displayName}");
              // Fluttertoast.showToast(msg: "Google Logged In: ${userCredential.user?.displayName}");
            }
          },
          child: const Text(
            'Sign in with Google',
          ),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          onPressed: signInWithFacebook,
          icon: const Icon(Icons.facebook),
          label: const Text('Login with Facebook'),
        ),
      ],
    );
  }
}
