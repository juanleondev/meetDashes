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
    apiKey: 'AIzaSyBF9qrWhktpAEl55_AD18V2AeqlXjC4Sn0',
    appId: '1:298027527036:web:08e2aba7d50d20d756d2f9',
    messagingSenderId: '298027527036',
    projectId: 'meetdashesrtfcl',
    authDomain: 'meetdashesrtfcl.firebaseapp.com',
    storageBucket: 'meetdashesrtfcl.appspot.com',
    measurementId: 'G-GWNHBPT0G1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWHIJybsYeCObGmd522oWnMD2LtGBgFAo',
    appId: '1:298027527036:android:a7aafc9fce02353856d2f9',
    messagingSenderId: '298027527036',
    projectId: 'meetdashesrtfcl',
    storageBucket: 'meetdashesrtfcl.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0CQvS5yTujtNTNWJLDhDx0bf5yyiyxgA',
    appId: '1:298027527036:ios:798dec2d8821d25c56d2f9',
    messagingSenderId: '298027527036',
    projectId: 'meetdashesrtfcl',
    storageBucket: 'meetdashesrtfcl.appspot.com',
    iosBundleId: 'com.example.meetDashes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0CQvS5yTujtNTNWJLDhDx0bf5yyiyxgA',
    appId: '1:298027527036:ios:114bdfc9bc5a2c8156d2f9',
    messagingSenderId: '298027527036',
    projectId: 'meetdashesrtfcl',
    storageBucket: 'meetdashesrtfcl.appspot.com',
    iosBundleId: 'com.example.meetDashes.RunnerTests',
  );
}
