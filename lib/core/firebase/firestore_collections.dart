// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/firestore_collections.dart
// Single source of truth for all Firestore collection / field paths.
// ════════════════════════════════════════════════════════════════

/// Centralized Firestore collection and document naming constants.
///
/// Keeping these in one place prevents typo-based bugs and makes
/// schema changes trivial.
class FirestoreCollections {
  FirestoreCollections._();

  // ── TOP-LEVEL COLLECTIONS ──────────────────────────────────
  static const String users = 'users';
  static const String earnings = 'earnings';
  static const String withdrawals = 'withdrawals';
  static const String teamTree = 'team_tree';
  static const String notifications = 'notifications';
  static const String appConfig = 'app_config';

  // ── SUB-COLLECTIONS ───────────────────────────────────────
  static const String earningRecords = 'records';
  static const String notificationMessages = 'messages';

  // ── SINGLETON DOCUMENTS ───────────────────────────────────
  static const String appConfigSettingsDoc = 'settings';

  // ── HELPERS (build full paths) ────────────────────────────
  /// users/{userId}
  static String userDoc(String userId) => '$users/$userId';

  /// earnings/{userId}/records
  static String earningRecordsPath(String userId) =>
      '$earnings/$userId/$earningRecords';

  /// notifications/{userId}/messages
  static String notificationMessagesPath(String userId) =>
      '$notifications/$userId/$notificationMessages';

  /// app_config/settings
  static String get appConfigSettingsPath => '$appConfig/$appConfigSettingsDoc';
}

/// Field-name constants for the `users` document.
class UserFields {
  UserFields._();
  static const String uid = 'uid';
  static const String memberId = 'memberId';
  static const String fullName = 'fullName';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String profilePhotoUrl = 'profilePhotoUrl';
  static const String dateOfBirth = 'dateOfBirth';
  static const String address = 'address';
  static const String joiningDate = 'joiningDate';
  static const String joiningFee = 'joiningFee';
  static const String joiningFeePaid = 'joiningFeePaid';
  static const String isActive = 'isActive';
  static const String sponsorId = 'sponsorId';
  static const String sponsorUid = 'sponsorUid';
  static const String level = 'level';
  static const String position = 'position';
  static const String referralCode = 'referralCode';
  static const String rank = 'rank';
  static const String rankLevel = 'rankLevel';
  static const String rankPoints = 'rankPoints';
  static const String rankAchievedDate = 'rankAchievedDate';
  static const String totalTeamSize = 'totalTeamSize';
  static const String directReferrals = 'directReferrals';
  static const String activeDirectReferrals = 'activeDirectReferrals';
  static const String thisMonthNewJoinings = 'thisMonthNewJoinings';
  static const String todayEarnings = 'todayEarnings';
  static const String weeklyEarnings = 'weeklyEarnings';
  static const String monthlyEarnings = 'monthlyEarnings';
  static const String lastMonthEarnings = 'lastMonthEarnings';
  static const String yearlyEarnings = 'yearlyEarnings';
  static const String grossCareerEarnings = 'grossCareerEarnings';
  static const String totalTeamEarnings = 'totalTeamEarnings';
  static const String availableBalance = 'availableBalance';
  static const String bankDetails = 'bankDetails';
  static const String upiDetails = 'upiDetails';
  static const String lastWithdrawalDate = 'lastWithdrawalDate';
  static const String withdrawalCountThisMonth = 'withdrawalCountThisMonth';
  static const String nextWithdrawalEligibleDate = 'nextWithdrawalEligibleDate';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String biometricEnabled = 'biometricEnabled';
  static const String notificationsEnabled = 'notificationsEnabled';
  static const String fcmToken = 'fcmToken';
  static const String createdAt = 'createdAt';
  static const String lastLogin = 'lastLogin';
  static const String lastSyncedAt = 'lastSyncedAt';
  static const String appVersion = 'appVersion';
}

/// Field-name constants for `earnings/{userId}/records/{docId}`.
class EarningFields {
  EarningFields._();
  static const String earningId = 'earningId';
  static const String type = 'type';
  static const String amount = 'amount';
  static const String fromUserId = 'fromUserId';
  static const String fromUserName = 'fromUserName';
  static const String fromMemberId = 'fromMemberId';
  static const String level = 'level';
  static const String commissionRate = 'commissionRate';
  static const String baseAmount = 'baseAmount';
  static const String description = 'description';
  static const String date = 'date';
  static const String month = 'month';
  static const String week = 'week';
  static const String status = 'status';
}

/// Field-name constants for `withdrawals/{docId}`.
class WithdrawalFields {
  WithdrawalFields._();
  static const String withdrawalId = 'withdrawalId';
  static const String userId = 'userId';
  static const String memberId = 'memberId';
  static const String memberName = 'memberName';
  static const String amount = 'amount';
  static const String method = 'method';
  static const String paymentDetails = 'paymentDetails';
  static const String status = 'status';
  static const String requestedAt = 'requestedAt';
  static const String processedAt = 'processedAt';
  static const String adminNote = 'adminNote';
  static const String transactionId = 'transactionId';
  static const String screenshotUrl = 'screenshotUrl';
  static const String withdrawalCount = 'withdrawalCount';
  static const String periodLabel = 'periodLabel';
}

/// Field-name constants for `notifications/{userId}/messages/{msgId}`.
class NotificationFields {
  NotificationFields._();
  static const String title = 'title';
  static const String body = 'body';
  static const String type = 'type';
  static const String isRead = 'isRead';
  static const String data = 'data';
  static const String createdAt = 'createdAt';
}

/// Reusable status strings for earnings & withdrawals.
class StatusValues {
  StatusValues._();
  // Earnings
  static const String credited = 'credited';
  static const String pending = 'pending';
  // Withdrawals
  static const String processing = 'processing';
  static const String completed = 'completed';
  static const String rejected = 'rejected';
  // User flags
  static const String active = 'active';
  static const String deactivated = 'deactivated';
}
