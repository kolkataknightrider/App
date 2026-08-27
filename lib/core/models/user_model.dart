// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/user_model.dart
// Member data model — maps to /users/{userId} document.
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import 'bank_details_model.dart';

class UserModel extends Equatable {
  // Personal Info
  final String uid;
  final String memberId;
  final String fullName;
  final String phone;
  final String email;
  final String? profilePhotoUrl;
  final DateTime? dateOfBirth;
  final String? address;
  final DateTime? joiningDate;
  final double joiningFee;
  final bool joiningFeePaid;
  final bool isActive;

  // MLM Structure
  final String? sponsorId;
  final String? sponsorUid;
  final int level;
  final String? position;
  final String referralCode;

  // Rank & Performance
  final String rank;
  final int rankLevel;
  final double rankPoints;
  final DateTime? rankAchievedDate;
  final int totalTeamSize;
  final int directReferrals;
  final int activeDirectReferrals;
  final int thisMonthNewJoinings;

  // Earnings Summary (cached totals)
  final double todayEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;
  final double lastMonthEarnings;
  final double yearlyEarnings;
  final double grossCareerEarnings;
  final double totalTeamEarnings;
  final double availableBalance;

  // Payment Details
  final BankDetailsModel? bankDetails;
  final UpiDetailsModel? upiDetails;

  // Withdrawal Control
  final DateTime? lastWithdrawalDate;
  final int withdrawalCountThisMonth;
  final DateTime? nextWithdrawalEligibleDate;

  // App Settings
  final String language;
  final String theme;
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final String? fcmToken;

  // Metadata
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final DateTime? lastSyncedAt;
  final String appVersion;

  const UserModel({
    required this.uid,
    required this.memberId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.profilePhotoUrl,
    this.dateOfBirth,
    this.address,
    this.joiningDate,
    this.joiningFee = 199.0,
    this.joiningFeePaid = true,
    this.isActive = true,
    this.sponsorId,
    this.sponsorUid,
    this.level = 0,
    this.position,
    required this.referralCode,
    this.rank = 'Associate',
    this.rankLevel = 1,
    this.rankPoints = 0.0,
    this.rankAchievedDate,
    this.totalTeamSize = 0,
    this.directReferrals = 0,
    this.activeDirectReferrals = 0,
    this.thisMonthNewJoinings = 0,
    this.todayEarnings = 0.0,
    this.weeklyEarnings = 0.0,
    this.monthlyEarnings = 0.0,
    this.lastMonthEarnings = 0.0,
    this.yearlyEarnings = 0.0,
    this.grossCareerEarnings = 0.0,
    this.totalTeamEarnings = 0.0,
    this.availableBalance = 0.0,
    this.bankDetails,
    this.upiDetails,
    this.lastWithdrawalDate,
    this.withdrawalCountThisMonth = 0,
    this.nextWithdrawalEligibleDate,
    this.language = 'en',
    this.theme = 'dark',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
    this.fcmToken,
    this.createdAt,
    this.lastLogin,
    this.lastSyncedAt,
    this.appVersion = '1.0.0',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      dateOfBirth:
          _dateFromJson(json['dateOfBirth']),
      address: json['address'] as String?,
      joiningDate: _dateFromJson(json['joiningDate']),
      joiningFee: (json['joiningFee'] as num?)?.toDouble() ?? 199.0,
      joiningFeePaid: json['joiningFeePaid'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      sponsorId: json['sponsorId'] as String?,
      sponsorUid: json['sponsorUid'] as String?,
      level: json['level'] as int? ?? 0,
      position: json['position'] as String?,
      referralCode: json['referralCode'] as String? ?? '',
      rank: json['rank'] as String? ?? 'Associate',
      rankLevel: json['rankLevel'] as int? ?? 1,
      rankPoints: (json['rankPoints'] as num?)?.toDouble() ?? 0.0,
      rankAchievedDate: _dateFromJson(json['rankAchievedDate']),
      totalTeamSize: json['totalTeamSize'] as int? ?? 0,
      directReferrals: json['directReferrals'] as int? ?? 0,
      activeDirectReferrals: json['activeDirectReferrals'] as int? ?? 0,
      thisMonthNewJoinings: json['thisMonthNewJoinings'] as int? ?? 0,
      todayEarnings: (json['todayEarnings'] as num?)?.toDouble() ?? 0.0,
      weeklyEarnings: (json['weeklyEarnings'] as num?)?.toDouble() ?? 0.0,
      monthlyEarnings: (json['monthlyEarnings'] as num?)?.toDouble() ?? 0.0,
      lastMonthEarnings:
          (json['lastMonthEarnings'] as num?)?.toDouble() ?? 0.0,
      yearlyEarnings: (json['yearlyEarnings'] as num?)?.toDouble() ?? 0.0,
      grossCareerEarnings:
          (json['grossCareerEarnings'] as num?)?.toDouble() ?? 0.0,
      totalTeamEarnings:
          (json['totalTeamEarnings'] as num?)?.toDouble() ?? 0.0,
      availableBalance:
          (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
      bankDetails: json['bankDetails'] != null
          ? BankDetailsModel.fromJson(
              Map<String, dynamic>.from(json['bankDetails']))
          : null,
      upiDetails: json['upiDetails'] != null
          ? UpiDetailsModel.fromJson(
              Map<String, dynamic>.from(json['upiDetails']))
          : null,
      lastWithdrawalDate: _dateFromJson(json['lastWithdrawalDate']),
      withdrawalCountThisMonth:
          json['withdrawalCountThisMonth'] as int? ?? 0,
      nextWithdrawalEligibleDate:
          _dateFromJson(json['nextWithdrawalEligibleDate']),
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'dark',
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      fcmToken: json['fcmToken'] as String?,
      createdAt: _dateFromJson(json['createdAt']),
      lastLogin: _dateFromJson(json['lastLogin']),
      lastSyncedAt: _dateFromJson(json['lastSyncedAt']),
      appVersion: json['appVersion'] as String? ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'memberId': memberId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'dateOfBirth': _dateToJson(dateOfBirth),
      'address': address,
      'joiningDate': _dateToJson(joiningDate),
      'joiningFee': joiningFee,
      'joiningFeePaid': joiningFeePaid,
      'isActive': isActive,
      'sponsorId': sponsorId,
      'sponsorUid': sponsorUid,
      'level': level,
      'position': position,
      'referralCode': referralCode,
      'rank': rank,
      'rankLevel': rankLevel,
      'rankPoints': rankPoints,
      'rankAchievedDate': _dateToJson(rankAchievedDate),
      'totalTeamSize': totalTeamSize,
      'directReferrals': directReferrals,
      'activeDirectReferrals': activeDirectReferrals,
      'thisMonthNewJoinings': thisMonthNewJoinings,
      'todayEarnings': todayEarnings,
      'weeklyEarnings': weeklyEarnings,
      'monthlyEarnings': monthlyEarnings,
      'lastMonthEarnings': lastMonthEarnings,
      'yearlyEarnings': yearlyEarnings,
      'grossCareerEarnings': grossCareerEarnings,
      'totalTeamEarnings': totalTeamEarnings,
      'availableBalance': availableBalance,
      'bankDetails': bankDetails?.toJson(),
      'upiDetails': upiDetails?.toJson(),
      'lastWithdrawalDate': _dateToJson(lastWithdrawalDate),
      'withdrawalCountThisMonth': withdrawalCountThisMonth,
      'nextWithdrawalEligibleDate':
          _dateToJson(nextWithdrawalEligibleDate),
      'language': language,
      'theme': theme,
      'biometricEnabled': biometricEnabled,
      'notificationsEnabled': notificationsEnabled,
      'fcmToken': fcmToken,
      'createdAt': _dateToJson(createdAt),
      'lastLogin': _dateToJson(lastLogin),
      'lastSyncedAt': _dateToJson(lastSyncedAt),
      'appVersion': appVersion,
    };
  }

  /// A copy of this user with the given fields replaced.
  UserModel copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? profilePhotoUrl,
    String? rank,
    int? rankLevel,
    int? totalTeamSize,
    int? directReferrals,
    double? availableBalance,
    double? grossCareerEarnings,
    String? language,
    String? theme,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    BankDetailsModel? bankDetails,
    UpiDetailsModel? upiDetails,
  }) {
    return UserModel(
      uid: uid,
      memberId: memberId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      dateOfBirth: dateOfBirth,
      address: address ?? this.address,
      joiningDate: joiningDate,
      joiningFee: joiningFee,
      joiningFeePaid: joiningFeePaid,
      isActive: isActive,
      sponsorId: sponsorId,
      sponsorUid: sponsorUid,
      level: level,
      position: position,
      referralCode: referralCode,
      rank: rank ?? this.rank,
      rankLevel: rankLevel ?? this.rankLevel,
      rankPoints: rankPoints,
      rankAchievedDate: rankAchievedDate,
      totalTeamSize: totalTeamSize ?? this.totalTeamSize,
      directReferrals: directReferrals ?? this.directReferrals,
      activeDirectReferrals: activeDirectReferrals,
      thisMonthNewJoinings: thisMonthNewJoinings,
      todayEarnings: todayEarnings,
      weeklyEarnings: weeklyEarnings,
      monthlyEarnings: monthlyEarnings,
      lastMonthEarnings: lastMonthEarnings,
      yearlyEarnings: yearlyEarnings,
      grossCareerEarnings: grossCareerEarnings ?? this.grossCareerEarnings,
      totalTeamEarnings: totalTeamEarnings,
      availableBalance: availableBalance ?? this.availableBalance,
      bankDetails: bankDetails ?? this.bankDetails,
      upiDetails: upiDetails ?? this.upiDetails,
      lastWithdrawalDate: lastWithdrawalDate,
      withdrawalCountThisMonth: withdrawalCountThisMonth,
      nextWithdrawalEligibleDate: nextWithdrawalEligibleDate,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      fcmToken: fcmToken,
      createdAt: createdAt,
      lastLogin: lastLogin,
      lastSyncedAt: lastSyncedAt,
      appVersion: appVersion,
    );
  }

  // ── helpers ──────────────────────────────────────────────
  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static dynamic _dateToJson(DateTime? value) => value?.millisecondsSinceEpoch;

  @override
  List<Object?> get props => [
        uid,
        memberId,
        fullName,
        phone,
        email,
        profilePhotoUrl,
        rank,
        rankLevel,
        availableBalance,
        grossCareerEarnings,
      ];
}

/// UPI details sub-model (stored unencrypted in the schema).
class UpiDetailsModel extends Equatable {
  final String upiId;
  final String upiName;
  final bool isVerified;

  const UpiDetailsModel({
    required this.upiId,
    required this.upiName,
    this.isVerified = false,
  });

  factory UpiDetailsModel.fromJson(Map<String, dynamic> json) {
    return UpiDetailsModel(
      upiId: json['upiId'] as String? ?? '',
      upiName: json['upiName'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'upiId': upiId,
        'upiName': upiName,
        'isVerified': isVerified,
      };

  UpiDetailsModel copyWith({String? upiId, String? upiName, bool? isVerified}) {
    return UpiDetailsModel(
      upiId: upiId ?? this.upiId,
      upiName: upiName ?? this.upiName,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [upiId, upiName, isVerified];
}
