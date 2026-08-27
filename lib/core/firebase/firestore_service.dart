// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/firestore_service.dart
// All Firestore read/write operations (SECTION 4 schema).
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partix/core/firebase/firestore_collections.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/models/earning_model.dart';
import 'package:partix/core/models/team_member_model.dart';
import 'package:partix/core/models/withdrawal_model.dart';
import 'package:partix/core/models/notification_model.dart';
import 'package:partix/core/models/bank_details_model.dart';

/// Centralized Firestore access layer.
class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── USERS ─────────────────────────────────────────────────
  Future<UserModel> getUser(String userId) async {
    final doc =
        await _db.collection(FirestoreCollections.users).doc(userId).get();
    if (!doc.exists) throw Exception('User document not found.');
    return UserModel.fromJson(doc.data()!);
  }

  /// Real-time stream of the current user's document.
  Stream<UserModel> streamUser(String userId) {
    return _db
        .collection(FirestoreCollections.users)
        .doc(userId)
        .snapshots()
        .map((snap) => UserModel.fromJson(snap.data() ?? {}));
  }

  /// Updates a subset of user fields (security rules restrict which).
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    data['lastSyncedAt'] = DateTime.now().millisecondsSinceEpoch;
    await _db.collection(FirestoreCollections.users).doc(userId).update(data);
  }

  /// Saves (or creates) a user document.
  Future<void> saveUser(UserModel user) async {
    await _db
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateFcmToken(String userId, String token) async {
    await updateUser(userId, {'fcmToken': token});
  }

  // ── EARNINGS ──────────────────────────────────────────────
  /// Real-time stream of a user's earning records.
  Stream<List<EarningModel>> streamEarnings(String userId) {
    return _db
        .collection(FirestoreCollections.earnings)
        .doc(userId)
        .collection(FirestoreCollections.earningRecords)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => EarningModel.fromJson(d.data())).toList());
  }

  /// Paginated earnings for the "view all" screen.
  Future<List<EarningModel>> getEarningsPage(
    String userId, {
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    Query query = _db
        .collection(FirestoreCollections.earnings)
        .doc(userId)
        .collection(FirestoreCollections.earningRecords)
        .orderBy('date', descending: true)
        .limit(limit);
    if (lastDoc != null) query = query.startAfterDocument(lastDoc);
    final snap = await query.get();
    return snap.docs
        .map((d) => EarningModel.fromJson(d.data()! as Map<String, dynamic>))
        .toList();
  }

  // ── WITHDRAWALS ───────────────────────────────────────────
  Future<void> createWithdrawal(Map<String, dynamic> data) async {
    await _db.collection(FirestoreCollections.withdrawals).add(data);
  }

  Stream<List<WithdrawalModel>> streamWithdrawals(String userId) {
    return _db
        .collection(FirestoreCollections.withdrawals)
        .where('userId', isEqualTo: userId)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => WithdrawalModel.fromJson(d.data())).toList());
  }

  Future<void> cancelWithdrawal(String withdrawalId) async {
    await _db
        .collection(FirestoreCollections.withdrawals)
        .doc(withdrawalId)
        .delete();
  }

  /// Returns the user's withdrawal documents for the current month.
  Future<List<WithdrawalModel>> getMonthWithdrawals(
      String userId, DateTime now) async {
    final startOfMonth = DateTime(now.year, now.month, 1);
    final snap = await _db
        .collection(FirestoreCollections.withdrawals)
        .where('userId', isEqualTo: userId)
        .where('requestedAt',
            isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
        .get();
    return snap.docs.map((d) => WithdrawalModel.fromJson(d.data())).toList();
  }

  // ── TEAM TREE ─────────────────────────────────────────────
  Future<TeamMemberModel?> getTeamNode(String userId) async {
    final doc =
        await _db.collection(FirestoreCollections.teamTree).doc(userId).get();
    if (!doc.exists) return null;
    return TeamMemberModel.fromJson(doc.data()!);
  }

  /// Fetch the team nodes for a list of user ids (children expansion).
  Future<List<TeamMemberModel>> getTeamNodes(List<String> userIds) async {
    if (userIds.isEmpty) return const [];
    final snaps = await Future.wait(userIds.map(
        (id) => _db.collection(FirestoreCollections.teamTree).doc(id).get()));
    return snaps
        .where((d) => d.exists)
        .map((d) => TeamMemberModel.fromJson(d.data()!))
        .toList();
  }

  // ── NOTIFICATIONS ─────────────────────────────────────────
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _db
        .collection(FirestoreCollections.notifications)
        .doc(userId)
        .collection(FirestoreCollections.notificationMessages)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => NotificationModel.fromJson(d.data(), d.id))
            .toList());
  }

  Future<void> markNotificationRead(String userId, String messageId) async {
    await _db
        .collection(FirestoreCollections.notifications)
        .doc(userId)
        .collection(FirestoreCollections.notificationMessages)
        .doc(messageId)
        .update({'isRead': true});
  }

  // ── APP CONFIG ────────────────────────────────────────────
  Future<Map<String, dynamic>?> getAppConfig() async {
    final doc = await _db
        .collection(FirestoreCollections.appConfig)
        .doc(FirestoreCollections.appConfigSettingsDoc)
        .get();
    return doc.data();
  }

  /// Updates bank details (allowed fields only).
  Future<void> updateBankDetails(String userId, BankDetailsModel bank) async {
    await updateUser(userId, {
      'bankDetails': bank.toJson(),
    });
  }

  /// Updates UPI details.
  Future<void> updateUpiDetails(String userId, Map<String, dynamic> upi) async {
    await updateUser(userId, {'upiDetails': upi});
  }

  /// Sets the user's preferred language/theme.
  Future<void> updatePreferences(
    String userId, {
    String? language,
    String? theme,
    bool? biometricEnabled,
    bool? notificationsEnabled,
  }) async {
    final data = <String, dynamic>{};
    if (language != null) data['language'] = language;
    if (theme != null) data['theme'] = theme;
    if (biometricEnabled != null) data['biometricEnabled'] = biometricEnabled;
    if (notificationsEnabled != null) {
      data['notificationsEnabled'] = notificationsEnabled;
    }
    await updateUser(userId, data);
  }
}
