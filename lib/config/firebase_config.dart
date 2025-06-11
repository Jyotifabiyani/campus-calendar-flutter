import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const FirebaseOptions defaultOptions = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: defaultOptions,
    );
  }
} 