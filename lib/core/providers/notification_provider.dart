// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/notification_provider.dart
// Notification center state (SECTION 13).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:partix/core/firebase/firestore_service.dart';
import 'package:partix/core/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _items = const [];
  bool _loading = false;
  Object? _error;

  List<NotificationModel> get items => _items;
  bool get loading => _loading;
  Object? get error => _error;

  int get unreadCount => _items.where((n) => !n.isRead).length;

  final FirestoreService _firestore = FirestoreService.instance;

  void watch(String userId) {
    _loading = true;
    notifyListeners();
    _firestore.streamNotifications(userId).listen((list) {
      _items = list;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _loading = false;
      _error = e;
      notifyListeners();
    });
  }

  Future<void> markRead(String userId, String messageId) async {
    await _firestore.markNotificationRead(userId, messageId);
    _items = _items
        .map((n) => n.id == messageId ? n.copyWith(isRead: true) : n)
        .toList();
    notifyListeners();
  }
}
