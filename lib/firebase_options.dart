
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] 


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
    apiKey: 'AIzaSyBjWBa3C88GFQ6m3XH4VjkmkHrZlzvcO9o',
    appId: '1:468012302937:web:f129ba8e100b55aabea748',
    messagingSenderId: '468012302937',
    projectId: 'app-ventas-auth',
    authDomain: 'app-ventas-auth.firebaseapp.com',
    storageBucket: 'app-ventas-auth.firebasestorage.app',
    measurementId: 'G-FW677W1DQC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvRbqB_a0NM3FGswzdNrQyP3rU__LknyY',
    appId: '1:468012302937:android:282dcde2dd647199bea748',
    messagingSenderId: '468012302937',
    projectId: 'app-ventas-auth',
    storageBucket: 'app-ventas-auth.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgArV69qYs6OkccmN29Mncdc3FY9oC_1o',
    appId: '1:468012302937:ios:e9405d5ba457af3abea748',
    messagingSenderId: '468012302937',
    projectId: 'app-ventas-auth',
    storageBucket: 'app-ventas-auth.firebasestorage.app',
    iosBundleId: 'com.example.appVentas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgArV69qYs6OkccmN29Mncdc3FY9oC_1o',
    appId: '1:468012302937:ios:e9405d5ba457af3abea748',
    messagingSenderId: '468012302937',
    projectId: 'app-ventas-auth',
    storageBucket: 'app-ventas-auth.firebasestorage.app',
    iosBundleId: 'com.example.appVentas',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBjWBa3C88GFQ6m3XH4VjkmkHrZlzvcO9o',
    appId: '1:468012302937:web:1ed9977adf221e2dbea748',
    messagingSenderId: '468012302937',
    projectId: 'app-ventas-auth',
    authDomain: 'app-ventas-auth.firebaseapp.com',
    storageBucket: 'app-ventas-auth.firebasestorage.app',
    measurementId: 'G-4CYD65L2RL',
  );
}
