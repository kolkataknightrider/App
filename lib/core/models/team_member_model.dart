// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/team_member_model.dart
// A single downline member — /team_tree/{userId}
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class TeamMemberModel extends Equatable {
  final String userId;
  final String memberId;
  final String fullName;
  final String? profilePhotoUrl;
  final String rank;
  final int rankLevel;
  final bool isActive;
  final String? sponsorId;
  final int level; // depth relative to the viewing user (1..5)
  final int directReferrals;
  final int totalDownline;
  final double monthlyEarnings;
  final DateTime? joiningDate;
  final List<String> children; // immediate children userIds

  const TeamMemberModel({
    required this.userId,
    required this.memberId,
    required this.fullName,
    this.profilePhotoUrl,
    required this.rank,
    required this.rankLevel,
    this.isActive = true,
    this.sponsorId,
    this.level = 1,
    this.directReferrals = 0,
    this.totalDownline = 0,
    this.monthlyEarnings = 0.0,
    this.joiningDate,
    this.children = const [],
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json, {int level = 1}) {
    return TeamMemberModel(
      userId: json['userId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      rank: json['rank'] as String? ?? 'Associate',
      rankLevel: json['rankLevel'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      sponsorId: json['sponsorId'] as String?,
      level: json['level'] as int? ?? level,
      directReferrals: json['directReferrals'] as int? ?? 0,
      totalDownline: json['totalDownline'] as int? ?? 0,
      monthlyEarnings:
          (json['monthlyEarnings'] as num?)?.toDouble() ?? 0.0,
      joiningDate: _dateFromJson(json['joiningDate']),
      children: _stringList(json['children']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'memberId': memberId,
        'fullName': fullName,
        'profilePhotoUrl': profilePhotoUrl,
        'rank': rank,
        'rankLevel': rankLevel,
        'isActive': isActive,
        'sponsorId': sponsorId,
        'level': level,
        'directReferrals': directReferrals,
        'totalDownline': totalDownline,
        'monthlyEarnings': monthlyEarnings,
        'joiningDate': joiningDate?.millisecondsSinceEpoch,
        'children': children,
      };

  TeamMemberModel copyWith({
    int? level,
    List<String>? children,
    int? totalDownline,
    bool? isActive,
  }) {
    return TeamMemberModel(
      userId: userId,
      memberId: memberId,
      fullName: fullName,
      profilePhotoUrl: profilePhotoUrl,
      rank: rank,
      rankLevel: rankLevel,
      isActive: isActive ?? this.isActive,
      sponsorId: sponsorId,
      level: level ?? this.level,
      directReferrals: directReferrals,
      totalDownline: totalDownline ?? this.totalDownline,
      monthlyEarnings: monthlyEarnings,
      joiningDate: joiningDate,
      children: children ?? this.children,
    );
  }

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

  @override
  List<Object?> get props => [userId, memberId, fullName, rank, level];
}
