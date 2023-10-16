import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omega_chat/screens/home_screen.dart';
import 'package:omega_chat/screens/new_user.dart';
import 'package:omega_chat/utils/firebase.dart';

class LoginCredentials extends StatefulWidget {
  const LoginCredentials({super.key});

  @override
  State<LoginCredentials> createState() => _LoginCredentialsState();
}

class _LoginCredentialsState extends State<LoginCredentials> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // var userExist = false;
  // var password = 'cnwoincrvboncwcbc4r4.;,,l/32';

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;
      print(googleUser);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(credential);
      // var list = await _auth.fetchSignInMethodsForEmail('mzain.akhtar3@gmail.com');
      // print(list.length);
      // userExist =
      //     (await _auth.fetchSignInMethodsForEmail(googleUser.email)).isNotEmpty;
      // print(userExist);
      // Map<String, String> userDetails = {};
      // if (!userExist) {
      //   userDetails = await Navigator.of(context).push(
      //     createRoute(googleUser.displayName, googleUser.photoUrl),
      //   );
      //   print(userDetails);
      // }

      final userCredential = await _auth.signInWithCredential(credential);
      print('Fresh User: ${userCredential.user}');
      // await userCredential.user
      //     ?.updateDisplayName(userDetails['name'] ?? googleUser.displayName);
      // if (userDetails['photoUrl'] != null) {
      //   final photoUrl = await uploadImageToFirebase(userDetails['photoUrl']!);
      //   await userCredential.user
      //       ?.updatePhotoURL(photoUrl ?? googleUser.photoUrl!);
      // } else {
      //   await userCredential.user?.updatePhotoURL(googleUser.photoUrl!);
      // }
      // print(userCredential.user);
      return userCredential;

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
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      final user = await FacebookAuth.instance.getUserData();
      print(user);
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      print('Fresh User: ${userCredential.user}');
      // userCredential.user?.updateDisplayName(user['name']);
      // userCredential.user?.updatePhotoURL(user['picture']['data']['url']);
      // print(userCredential.user);
      return userCredential;
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
        ElevatedButton.icon(
          icon: Image.asset(
            'assets/images/google_logo.png',
            width: 25,
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          onPressed: signInWithGoogle,
          label: const Text(
            'Sign in with Google',
          ),
        ),
        const SizedBox(height: 5.0),
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
          label: const Text('Sign in with Facebook'),
        ),
      ],
    );
  }
}
