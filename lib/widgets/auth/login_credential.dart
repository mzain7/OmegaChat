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

  var userExist = false;

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
      userExist =
          (await _auth.fetchSignInMethodsForEmail(googleUser.email)).isNotEmpty;
      print(userExist);
      Map<String, String> userDetails = {};
      if (!userExist) {
        userDetails = await Navigator.of(context).push(
          createRoute(googleUser.displayName, googleUser.photoUrl!),
        );
        print(userDetails);
      }

      final userCredential = await _auth.signInWithCredential(credential);
      print('Fresh User: ${userCredential.user}');
      await userCredential.user
          ?.updateDisplayName(userDetails['name'] ?? googleUser.displayName);
      if (userDetails['photoUrl'] != null) {
        final photoUrl = await uploadImageToFirebase(userDetails['photoUrl']!);
        await userCredential.user
            ?.updatePhotoURL(userDetails['photoUrl'] ?? googleUser.photoUrl!);
      } else {
        await userCredential.user?.updatePhotoURL(googleUser.photoUrl!);
      }
      print(userCredential.user);
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
      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      userCredential.user?.updateDisplayName(user['name']);
      userCredential.user?.updatePhotoURL(user['picture']['data']['url']);
      print(userCredential.user);
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
