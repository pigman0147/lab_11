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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBBAJ8xXy1tOTzHFv_0vLGumsvFNrcolg8',
    appId: '1:718741099363:web:ffd242aefb5638d76d3956',
    messagingSenderId: '718741099363',
    projectId: 'pj029-d93ae',
    authDomain: 'pj029-d93ae.firebaseapp.com',
    storageBucket: 'pj029-d93ae.firebasestorage.app',
    measurementId: 'G-MT03F4VF9P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDL9FXwCFhXXhTigt9yZreBMYECoLkFHUU',
    appId: '1:718741099363:android:06b8daf867c700fd6d3956',
    messagingSenderId: '718741099363',
    projectId: 'pj029-d93ae',
    storageBucket: 'pj029-d93ae.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6NIa3LXoFKf0vJaTXZWync9O_NDNgUOU',
    appId: '1:718741099363:ios:ca552ae6d28eddf96d3956',
    messagingSenderId: '718741099363',
    projectId: 'pj029-d93ae',
    storageBucket: 'pj029-d93ae.firebasestorage.app',
    iosBundleId: 'com.example.lab11',
  );

}