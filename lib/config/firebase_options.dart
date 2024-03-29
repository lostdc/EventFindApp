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
    apiKey: 'AIzaSyDqgyZcuQInsJfZ-ihji32qYvtlDjy_zCA',
    appId: '1:442989921414:web:8508a49baaf7bd41ee7d07',
    messagingSenderId: '442989921414',
    projectId: 'eventfind-ad0e3',
    authDomain: 'eventfind-ad0e3.firebaseapp.com',
    storageBucket: 'eventfind-ad0e3.appspot.com',
    measurementId: 'G-76Y2QQQ934',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYpdGbB0iKVwEvGq8lS4pkm91faO92wRg',
    appId: '1:442989921414:android:fbd02a72dd47c9b3ee7d07',
    messagingSenderId: '442989921414',
    projectId: 'eventfind-ad0e3',
    storageBucket: 'eventfind-ad0e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJZntezXsbSY7cAQSaB8X66wucxrHUjEY',
    appId: '1:442989921414:ios:0b66e9d0c1bafff6ee7d07',
    messagingSenderId: '442989921414',
    projectId: 'eventfind-ad0e3',
    storageBucket: 'eventfind-ad0e3.appspot.com',
    iosClientId: '442989921414-makt346n1hgs4um94qspe5c1m9scft6j.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventFind',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJZntezXsbSY7cAQSaB8X66wucxrHUjEY',
    appId: '1:442989921414:ios:0b66e9d0c1bafff6ee7d07',
    messagingSenderId: '442989921414',
    projectId: 'eventfind-ad0e3',
    storageBucket: 'eventfind-ad0e3.appspot.com',
    iosClientId: '442989921414-makt346n1hgs4um94qspe5c1m9scft6j.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventFind',
  );
}
