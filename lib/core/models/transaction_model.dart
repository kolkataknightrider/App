// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/transaction_model.dart
// Generic transaction-history entry (wallet ledger).
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final String type; // credit / debit
  final String category; // referral / rank_bonus / withdrawal / ...
  final double amount;
  final DateTime date;
  final String description;
  final String? refId;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
    this.refId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'credit',
      category: json['category'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: _dateFromJson(json['date']) ?? DateTime.now(),
      description: json['description'] as String? ?? '',
      refId: json['refId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'category': category,
        'amount': amount,
        'date': date.millisecondsSinceEpoch,
        'description': description,
        'refId': refId,
      };

  bool get isCredit => type == 'credit';

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  List<Object?> get props => [id, type, amount, date];
}
