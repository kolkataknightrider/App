// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/withdrawal_model.dart
// Withdrawal request — /withdrawals/{docId}
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class WithdrawalModel extends Equatable {
  final String withdrawalId;
  final String userId;
  final String memberId;
  final String memberName;
  final double amount;
  final String method; // upi / bank
  final PaymentDetailsModel paymentDetails;
  final String status; // pending / processing / completed / rejected
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? adminNote;
  final String? transactionId;
  final String? screenshotUrl;
  final int withdrawalCount;
  final String periodLabel;

  const WithdrawalModel({
    required this.withdrawalId,
    required this.userId,
    required this.memberId,
    required this.memberName,
    required this.amount,
    required this.method,
    required this.paymentDetails,
    required this.status,
    required this.requestedAt,
    this.processedAt,
    this.adminNote,
    this.transactionId,
    this.screenshotUrl,
    this.withdrawalCount = 1,
    required this.periodLabel,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      withdrawalId: json['withdrawalId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      memberName: json['memberName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] as String? ?? 'upi',
      paymentDetails: json['paymentDetails'] != null
          ? PaymentDetailsModel.fromJson(
              Map<String, dynamic>.from(json['paymentDetails']))
          : const PaymentDetailsModel(),
      status: json['status'] as String? ?? 'pending',
      requestedAt: _dateFromJson(json['requestedAt']) ?? DateTime.now(),
      processedAt: _dateFromJson(json['processedAt']),
      adminNote: json['adminNote'] as String?,
      transactionId: json['transactionId'] as String?,
      screenshotUrl: json['screenshotUrl'] as String?,
      withdrawalCount: json['withdrawalCount'] as int? ?? 1,
      periodLabel: json['periodLabel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'withdrawalId': withdrawalId,
        'userId': userId,
        'memberId': memberId,
        'memberName': memberName,
        'amount': amount,
        'method': method,
        'paymentDetails': paymentDetails.toJson(),
        'status': status,
        'requestedAt': requestedAt.millisecondsSinceEpoch,
        'processedAt': processedAt?.millisecondsSinceEpoch,
        'adminNote': adminNote,
        'transactionId': transactionId,
        'screenshotUrl': screenshotUrl,
        'withdrawalCount': withdrawalCount,
        'periodLabel': periodLabel,
      };

  bool get canCancel {
    if (status != 'pending') return false;
    // only within 30 minutes of submission
    return DateTime.now().difference(requestedAt).inMinutes <= 30;
  }

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  List<Object?> get props =>
      [withdrawalId, amount, method, status, requestedAt];
}

/// Payment details snapshot stored on the withdrawal document.
class PaymentDetailsModel {
  final String? upiId;
  final String? accountNumber; // last 4 digits only
  final String? bankName;
  final String? ifscCode;

  const PaymentDetailsModel({
    this.upiId,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      upiId: json['upiId'] as String?,
      accountNumber: json['accountNumber'] as String?,
      bankName: json['bankName'] as String?,
      ifscCode: json['ifscCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'upiId': upiId,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'ifscCode': ifscCode,
      };
}
