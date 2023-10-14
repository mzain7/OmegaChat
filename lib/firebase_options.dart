// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCCbvVPQCIazLaoWDM5IgKToxwXHyHf4vQ',
    appId: '1:86083309951:web:c8d331728ce04137400a4a',
    messagingSenderId: '86083309951',
    projectId: 'omega-chat-fd459',
    authDomain: 'omega-chat-fd459.firebaseapp.com',
    storageBucket: 'omega-chat-fd459.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCstELTG4XRSIonOpR2xTrJgxOrlhaO76k',
    appId: '1:86083309951:android:d266125380239a31400a4a',
    messagingSenderId: '86083309951',
    projectId: 'omega-chat-fd459',
    storageBucket: 'omega-chat-fd459.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMpM6kDMYB2C2ckjPxH5aRao3YazCvd-4',
    appId: '1:86083309951:ios:40c6cda1649eee46400a4a',
    messagingSenderId: '86083309951',
    projectId: 'omega-chat-fd459',
    storageBucket: 'omega-chat-fd459.appspot.com',
    iosClientId: '86083309951-fth2t1fmr48dla8l35icsq57nmsclb7i.apps.googleusercontent.com',
    iosBundleId: 'com.example.omegaChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMpM6kDMYB2C2ckjPxH5aRao3YazCvd-4',
    appId: '1:86083309951:ios:70db9fa0b95424fa400a4a',
    messagingSenderId: '86083309951',
    projectId: 'omega-chat-fd459',
    storageBucket: 'omega-chat-fd459.appspot.com',
    iosClientId: '86083309951-ldhqg3taaikmiov25ns0migqpucj491a.apps.googleusercontent.com',
    iosBundleId: 'com.example.omegaChat.RunnerTests',
  );
}
