// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/fcm_service.dart
// Push notifications — FCM setup, token, and handlers (SECTION 13).
// ════════════════════════════════════════════════════════════════

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:partix/core/services/offline_sync_service.dart';

/// FCM lifecycle: permission, token, foreground/background handling.
class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Requests permission (iOS) and returns the FCM token.
  Future<String?> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return null;
    }
    final token = await _messaging.getToken();
    // Background handler must be a top-level function (see main.dart).
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return token;
  }

  /// The current FCM registration token.
  Future<String?> getToken() => _messaging.getToken();

  /// Stream of messages received while the app is in the foreground.
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Stream of messages that opened the app from a terminated state.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Saves the token locally (so the repo can push it to Firestore).
  Future<void> persistToken(String token) async {
    await OfflineSyncService.instance.saveSession({'fcmToken': token});
  }
}

/// Top-level background message handler (required by FCM).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No Firebase.initializeApp needed for background data messages on
  // recent versions; for notifications it's handled by the system tray.
  // Perform lightweight local persistence here if needed.
}
