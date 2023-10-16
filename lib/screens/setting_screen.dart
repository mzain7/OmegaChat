import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omega_chat/screens/new_user.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;
  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);
  static const contentStyleHeader = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  static const slogan =
      'Do not forget to play around with all sorts of colors, backgrounds, borders, etc.';

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   child: Center(
    //     child: Column(
    //       children: [

    //         Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
    //         Text(FirebaseAuth.instance.currentUser!.email.toString()),
    //         Image.network(FirebaseAuth.instance.currentUser!.photoURL.toString()),
    //         ElevatedButton(
    //           onPressed: () async {
    //             await FirebaseAuth.instance.signOut();
    //             GoogleSignIn().signOut();
    //           },
    //           child: const Text('Sign Out'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             FirebaseAuth.instance.currentUser?.sendEmailVerification();
    //           },
    //           child: const Text('Sign in Email'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             FirebaseAuth.instance.sendPasswordResetEmail(
    //                 email: FirebaseAuth.instance.currentUser!.email.toString());
    //           },
    //           child: const Text('Password Reset'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             // var data = FirebaseAuth.instance.currentUser?.providerData.removeLast();
    //             // Map<String, dynamic> x = jsonDecode(jsonEncode(data));
    //             // FirebaseAuth.instance.currentUser?.providerData.add(UserInfo.fromJson({...x, 'country': 'Pakistan'}));
    //             // UserInfo
    //             print(FirebaseAuth.instance.currentUser);
    //           },
    //           child: const Text('print'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             FirebaseAuth.instance.verifyPhoneNumber(
    //               verificationCompleted: (phoneAuthCredential) {
    //                 print(phoneAuthCredential);
    //               },
    //               verificationFailed: (error) {},
    //               codeSent: (verificationId, forceResendingToken) {},
    //               codeAutoRetrievalTimeout: (verificationId) {},
    //               phoneNumber: '+923174317202',
    //             );
    //           },
    //           child: const Text('phone'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const ShapeDecoration(
                shape: CircleBorder(),
              ),
              width: 100,
              height: 100,
              child: Image.network(
                FirebaseAuth.instance.currentUser!.photoURL.toString(),
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
                Text(FirebaseAuth.instance.currentUser!.email.toString()),
              ],
            ),
          ],
        ),
        Accordion(
            headerBorderColor: Colors.blueGrey,
            headerBorderColorOpened: Colors.transparent,
            // headerBorderWidth: 1,
            headerBackgroundColorOpened: Colors.black,
            contentBackgroundColor: Colors.white,
            contentBorderColor: Colors.black,
            contentBorderWidth: 3,
            contentHorizontalPadding: 20,
            scaleWhenAnimating: false,
            openAndCloseAnimation: true,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: [
              AccordionSection(
                isOpen: false,
                contentVerticalPadding: 20,
                leftIcon:
                    const Icon(Icons.text_fields_rounded, color: Colors.white),
                header: const Text('Account Settings', style: headerStyle),
                contentBackgroundColor: Colors.grey,
                content: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          createRoute(false),
                        );
                      },
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Personal Details',
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        user?.updatePassword('zxcvbnm');
                      },
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Upadte Password',
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        user?.verifyBeforeUpdateEmail('mzain49190@gmail.com');
                      },
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Upadte Email',
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        user?.sendEmailVerification();
                      },
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Verify Email',
                      ),
                    ),
                    ListTile(
                      onTap: () {
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
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Add Phone Number',
                      ),
                    ),
                  ],
                ),
              ),
              AccordionSection(
                isOpen: false,
                contentVerticalPadding: 20,
                leftIcon:
                    const Icon(Icons.text_fields_rounded, color: Colors.white),
                header: const Text('App Settings', style: headerStyle),
                contentBackgroundColor: Colors.grey,
                content: const Text('nciec'),
              ),
            ]),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            GoogleSignIn().signOut();
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
