// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/firebase_config.dart
// PARTIX Firebase configuration (REAL PROJECT CREDENTIALS APPLIED).
// ════════════════════════════════════════════════════════════════

import 'package:firebase_core/firebase_core.dart';

/// Central Firebase configuration for the PARTIX application.
class FirebaseConfig {
  // ╔═══════════════════════════════════════════════════════════╗
  // ║              ANDROID FIREBASE CREDENTIALS                ║
  // ╚═════════════════════════════════════════════════════════╝
  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: "AIzaSyALFWzqxTtcZvyeM10FlwnBLzfTN8u5Xmg",
    appId: "1:314306763234:android:46164f2f41a478db1a01bb",
    messagingSenderId: "314306763234",
    projectId: "partix-app-9ad69",
    storageBucket: "partix-app-9ad69.firebasestorage.app",
    databaseURL:
        "https://partix-app-9ad69-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  /// Whether the developer has supplied real credentials.
  static bool get isConfigured {
    return !androidOptions.apiKey.contains('YOUR_') &&
        !androidOptions.appId.contains('YOUR_') &&
        !androidOptions.projectId.contains('YOUR_');
  }

  /// Initialize Firebase before the Flutter widget tree is built.
  ///
  /// On Android the `google-services` Gradle plugin makes the native SDK
  /// auto-create the `[DEFAULT]` app from `android/app/google-services.json`
  /// *before* Dart runs. Calling [Firebase.initializeApp] again with
  /// explicit options would then throw `[core/duplicate-app]`, so we reuse
  /// the app that already exists and only create one when none is present.
  static Future<FirebaseApp> initialize() async {
    if (!isConfigured) {
      throw const FirebaseConfigException(
        'Firebase credentials are not configured. '
        'Open lib/core/firebase/firebase_config.dart and replace '
        'the YOUR_* placeholders with your real Firebase values.',
      );
    }

    // Reuse the app created natively by google-services.json.
    if (Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }

    try {
      return await Firebase.initializeApp(options: androidOptions);
    } on FirebaseException catch (e) {
      // Race with the native initializer — fall back to the existing app.
      if (e.code == 'duplicate-app') return Firebase.app();
      rethrow;
    }
  }
}

/// Thrown when Firebase has not been configured with real credentials.
class FirebaseConfigException implements Exception {
  const FirebaseConfigException(this.message);
  final String message;
  @override
  String toString() => 'FirebaseConfigException: $message';
}
