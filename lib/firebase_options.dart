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
    apiKey: 'AIzaSyC2PE9u7cXd-0is5EqQRtdFKb6oBVaIstA',
    appId: '1:131225270793:web:4e15ed1507540a8ae4d6d8',
    messagingSenderId: '131225270793',
    projectId: 'expiry-reminder-notification',
    authDomain: 'expiry-reminder-notification.firebaseapp.com',
    storageBucket: 'expiry-reminder-notification.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEkf6XTz2p4lh24pn1N3H6ov3_pki9-sw',
    appId: '1:131225270793:android:16add5c9e738b64de4d6d8',
    messagingSenderId: '131225270793',
    projectId: 'expiry-reminder-notification',
    storageBucket: 'expiry-reminder-notification.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXwSonDJNVGMg_2m2o-AbRnofckx8TLPg',
    appId: '1:131225270793:ios:3c70356d44888ca6e4d6d8',
    messagingSenderId: '131225270793',
    projectId: 'expiry-reminder-notification',
    storageBucket: 'expiry-reminder-notification.appspot.com',
    iosBundleId: 'com.example.expiryReminder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXwSonDJNVGMg_2m2o-AbRnofckx8TLPg',
    appId: '1:131225270793:ios:3c70356d44888ca6e4d6d8',
    messagingSenderId: '131225270793',
    projectId: 'expiry-reminder-notification',
    storageBucket: 'expiry-reminder-notification.appspot.com',
    iosBundleId: 'com.example.expiryReminder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2PE9u7cXd-0is5EqQRtdFKb6oBVaIstA',
    appId: '1:131225270793:web:eca010ad4e56eb4de4d6d8',
    messagingSenderId: '131225270793',
    projectId: 'expiry-reminder-notification',
    authDomain: 'expiry-reminder-notification.firebaseapp.com',
    storageBucket: 'expiry-reminder-notification.appspot.com',
  );
}
