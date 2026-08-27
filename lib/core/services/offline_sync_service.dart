// ════════════════════════════════════════════════════════════════
// FILE: lib/core/services/offline_sync_service.dart
// Offline-first architecture (SECTION 14). Hive local cache +
// connectivity monitoring + sync bookkeeping.
// ════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/earning_model.dart';
import '../models/team_member_model.dart';
import '../models/withdrawal_model.dart';
import '../models/notification_model.dart';

/// Hive box names (per SECTION 14 spec).
class HiveBoxes {
  HiveBoxes._();
  static const String user = 'user_box';
  static const String earnings = 'earnings_box';
  static const String team = 'team_box';
  static const String withdrawal = 'withdrawal_box';
  static const String config = 'config_box';
  static const String session = 'session_box';
  static const String notifications = 'notifications_box';
}

/// Manages local persistence, connectivity state, and sync timestamps.
class OfflineSyncService {
  OfflineSyncService._();

  static final OfflineSyncService instance = OfflineSyncService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  /// Emits connectivity changes (true = online).
  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Initialize Hive and begin monitoring connectivity.
  Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(HiveBoxes.user),
      Hive.openBox(HiveBoxes.earnings),
      Hive.openBox(HiveBoxes.team),
      Hive.openBox(HiveBoxes.withdrawal),
      Hive.openBox(HiveBoxes.config),
      Hive.openBox(HiveBoxes.session),
      Hive.openBox(HiveBoxes.notifications),
    ]);

    _connectivity.onConnectivityChanged.listen((result) {
      final online = !result.contains(ConnectivityResult.none);
      _isOnline = online;
      _connectionController.add(online);
    });

    final current = await _connectivity.checkConnectivity();
    _isOnline = !current.contains(ConnectivityResult.none);
  }

  // ── USER ──────────────────────────────────────────────────
  Future<void> cacheUser(UserModel user) async {
    final box = Hive.box(HiveBoxes.user);
    await box.put('current', user.toJson());
  }

  UserModel? getCachedUser() {
    final box = Hive.box(HiveBoxes.user);
    final data = box.get('current');
    if (data is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // ── EARNINGS ──────────────────────────────────────────────
  Future<void> cacheEarnings(List<EarningModel> earnings) async {
    final box = Hive.box(HiveBoxes.earnings);
    await box.put('list', earnings.map((e) => e.toJson()).toList());
  }

  List<EarningModel> getCachedEarnings() {
    final box = Hive.box(HiveBoxes.earnings);
    final data = box.get('list');
    if (data is List) {
      return data
          .map((e) => EarningModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return const [];
  }

  // ── TEAM ──────────────────────────────────────────────────
  Future<void> cacheTeam(List<TeamMemberModel> team) async {
    final box = Hive.box(HiveBoxes.team);
    await box.put('list', team.map((e) => e.toJson()).toList());
  }

  List<TeamMemberModel> getCachedTeam() {
    final box = Hive.box(HiveBoxes.team);
    final data = box.get('list');
    if (data is List) {
      return data
          .map((e) => TeamMemberModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return const [];
  }

  // ── WITHDRAWALS ───────────────────────────────────────────
  Future<void> cacheWithdrawals(List<WithdrawalModel> list) async {
    final box = Hive.box(HiveBoxes.withdrawal);
    await box.put('list', list.map((e) => e.toJson()).toList());
  }

  List<WithdrawalModel> getCachedWithdrawals() {
    final box = Hive.box(HiveBoxes.withdrawal);
    final data = box.get('list');
    if (data is List) {
      return data
          .map((e) => WithdrawalModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return const [];
  }

  // ── NOTIFICATIONS ─────────────────────────────────────────
  Future<void> cacheNotifications(List<NotificationModel> list) async {
    final box = Hive.box(HiveBoxes.notifications);
    await box.put(
      'list',
      list
          .map((e) => <String, dynamic>{'id': e.id, ...e.toJson()})
          .toList(),
    );
  }

  List<NotificationModel> getCachedNotifications() {
    final box = Hive.box(HiveBoxes.notifications);
    final data = box.get('list');
    if (data is List) {
      return data
          .map((e) =>
              NotificationModel.fromJson(Map<String, dynamic>.from(e), e['id']))
          .toList();
    }
    return const [];
  }

  // ── SESSION ───────────────────────────────────────────────
  Future<void> saveSession(Map<String, dynamic> session) async {
    final box = Hive.box(HiveBoxes.session);
    await box.put('data', session);
  }

  Map<String, dynamic>? getSession() {
    final box = Hive.box(HiveBoxes.session);
    final data = box.get('data');
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Clears all local caches (used on logout).
  Future<void> clearAll() async {
    await Future.wait([
      Hive.box(HiveBoxes.user).clear(),
      Hive.box(HiveBoxes.earnings).clear(),
      Hive.box(HiveBoxes.team).clear(),
      Hive.box(HiveBoxes.withdrawal).clear(),
      Hive.box(HiveBoxes.notifications).clear(),
      Hive.box(HiveBoxes.session).clear(),
      Hive.box(HiveBoxes.config).clear(),
    ]);
  }
}
