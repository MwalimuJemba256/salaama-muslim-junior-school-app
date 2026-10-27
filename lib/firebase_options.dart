// Generated for Salaama Muslim Junior School
// Project: salaama-muslim-junior-school
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-UMx9oCVtIONLXBXnK3HoZinKk4tTRzk',
    appId: '1:813734047854:android:514ea367113cc1c0a4367f',
    messagingSenderId: '813734047854',
    projectId: 'salaama-muslim-junior-school',
    storageBucket: 'salaama-muslim-junior-school.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-UMx9oCVtIONLXBXnK3HoZinKk4tTRzk',
    appId: '1:813734047854:android:514ea367113cc1c0a4367f',
    messagingSenderId: '813734047854',
    projectId: 'salaama-muslim-junior-school',
    storageBucket: 'salaama-muslim-junior-school.firebasestorage.app',
    iosBundleId: 'com.salaama.schoolapp',
  );
}
