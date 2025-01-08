// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDd0u5rQI3uAWbqkLEtW2Oz-nv6jKPFyOg',
    appId: '1:739496418811:web:a26399b2218eecfa067f5e',
    messagingSenderId: '739496418811',
    projectId: 'trailtales-59907',
    authDomain: 'trailtales-59907.firebaseapp.com',
    storageBucket: 'trailtales-59907.firebasestorage.app',
    measurementId: 'G-FZZS2P5953',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyItlV2-W8DCWQcYw9q74fUvkM2HQ2JCA',
    appId: '1:739496418811:android:5d495495b4e01901067f5e',
    messagingSenderId: '739496418811',
    projectId: 'trailtales-59907',
    storageBucket: 'trailtales-59907.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbh4QxR1ltx6PiI7uTyafGuTGz3S6aJ7Y',
    appId: '1:739496418811:ios:e27d9302422912f4067f5e',
    messagingSenderId: '739496418811',
    projectId: 'trailtales-59907',
    storageBucket: 'trailtales-59907.firebasestorage.app',
    iosBundleId: 'com.example.trailTales',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbh4QxR1ltx6PiI7uTyafGuTGz3S6aJ7Y',
    appId: '1:739496418811:ios:e27d9302422912f4067f5e',
    messagingSenderId: '739496418811',
    projectId: 'trailtales-59907',
    storageBucket: 'trailtales-59907.firebasestorage.app',
    iosBundleId: 'com.example.trailTales',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDd0u5rQI3uAWbqkLEtW2Oz-nv6jKPFyOg',
    appId: '1:739496418811:web:74d96cb9d5c96752067f5e',
    messagingSenderId: '739496418811',
    projectId: 'trailtales-59907',
    authDomain: 'trailtales-59907.firebaseapp.com',
    storageBucket: 'trailtales-59907.firebasestorage.app',
    measurementId: 'G-ML57RN5KN1',
  );

}