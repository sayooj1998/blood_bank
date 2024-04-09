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
    apiKey: 'AIzaSyCm89EzyboC0zxvSDZVPB0GSlJ1vm84oYs',
    appId: '1:249163731164:web:eb0e01ff40de91fa78e419',
    messagingSenderId: '249163731164',
    projectId: 'blood-bank-annur',
    authDomain: 'blood-bank-annur.firebaseapp.com',
    storageBucket: 'blood-bank-annur.appspot.com',
    measurementId: 'G-6G79S5R8JD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCMoZ2lrgn0OKjC9u6XOgow8avYvOP8rGE',
    appId: '1:249163731164:android:4ed3df8c20bc1bb678e419',
    messagingSenderId: '249163731164',
    projectId: 'blood-bank-annur',
    storageBucket: 'blood-bank-annur.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnLgOizOMnejTNmW2mg6U0IJd7vgZx5AE',
    appId: '1:249163731164:ios:4fd1563a1149c70178e419',
    messagingSenderId: '249163731164',
    projectId: 'blood-bank-annur',
    storageBucket: 'blood-bank-annur.appspot.com',
    iosBundleId: 'com.example.bloodBank',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnLgOizOMnejTNmW2mg6U0IJd7vgZx5AE',
    appId: '1:249163731164:ios:43d26e968b593ef578e419',
    messagingSenderId: '249163731164',
    projectId: 'blood-bank-annur',
    storageBucket: 'blood-bank-annur.appspot.com',
    iosBundleId: 'com.example.bloodBank.RunnerTests',
  );
}