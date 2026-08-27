// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/earning_model.dart
// Earning record model — /earnings/{userId}/records/{docId}
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class EarningModel extends Equatable {
  final String earningId;
  final String type; // direct_referral, level_2_commission, ...
  final double amount;
  final String fromUserId;
  final String fromUserName;
  final String fromMemberId;
  final int level; // 1..5
  final double commissionRate;
  final double baseAmount;
  final String description;
  final DateTime date;
  final String month; // 2024-01
  final String week; // 2024-W03
  final String status; // credited / pending

  const EarningModel({
    required this.earningId,
    required this.type,
    required this.amount,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromMemberId,
    required this.level,
    required this.commissionRate,
    required this.baseAmount,
    required this.description,
    required this.date,
    required this.month,
    required this.week,
    this.status = 'credited',
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      earningId: json['earningId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      fromUserId: json['fromUserId'] as String? ?? '',
      fromUserName: json['fromUserName'] as String? ?? '',
      fromMemberId: json['fromMemberId'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
      baseAmount: (json['baseAmount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      date: _dateFromJson(json['date']) ?? DateTime.now(),
      month: json['month'] as String? ?? '',
      week: json['week'] as String? ?? '',
      status: json['status'] as String? ?? 'credited',
    );
  }

  Map<String, dynamic> toJson() => {
        'earningId': earningId,
        'type': type,
        'amount': amount,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromMemberId': fromMemberId,
        'level': level,
        'commissionRate': commissionRate,
        'baseAmount': baseAmount,
        'description': description,
        'date': date.millisecondsSinceEpoch,
        'month': month,
        'week': week,
        'status': status,
      };

  /// Human-readable label for the earning type.
  String get typeLabel {
    switch (type) {
      case 'direct_referral':
        return 'L1 Commission';
      case 'level_2_commission':
        return 'L2 Commission';
      case 'level_3_commission':
        return 'L3 Commission';
      case 'level_4_commission':
        return 'L4 Commission';
      case 'level_5_commission':
        return 'L5 Commission';
      case 'rank_bonus':
        return 'Rank Bonus';
      case 'performance_bonus':
        return 'Performance Bonus';
      default:
        return type;
    }
  }

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  List<Object?> get props => [
        earningId,
        type,
        amount,
        fromUserId,
        level,
        date,
        status,
      ];
}
