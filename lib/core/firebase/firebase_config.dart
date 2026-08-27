// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/firebase_config.dart
// PARTIX Firebase configuration (REAL PROJECT CREDENTIALS APPLIED).
// ════════════════════════════════════════════════════════════════

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
  static Future<void> initialize() async {
    if (!isConfigured) {
      throw const FirebaseConfigException(
        'Firebase credentials are not configured. '
        'Open lib/core/firebase/firebase_config.dart and replace '
        'the YOUR_* placeholders with your real Firebase values.',
      );
    }
    await Firebase.initializeApp(options: androidOptions);
  }
}

/// Thrown when Firebase has not been configured with real credentials.
class FirebaseConfigException implements Exception {
  const FirebaseConfigException(this.message);
  final String message;
  @override
  String toString() => 'FirebaseConfigException: $message';
}
