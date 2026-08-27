// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/bank_details_model.dart
// Bank account model (account number is encrypted at rest).
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class BankDetailsModel extends Equatable {
  final String accountHolder;
  /// Encrypted value (see utils/encryption_helper.dart). In the DB this
  /// is ciphertext; the app decrypts locally for display of last 4.
  final String accountNumber; // encrypted
  final String ifscCode;
  final String bankName;
  final String branchName;
  final bool isVerified;
  final bool isPrimary;

  const BankDetailsModel({
    required this.accountHolder,
    required this.accountNumber, // encrypted
    required this.ifscCode,
    required this.bankName,
    this.branchName = '',
    this.isVerified = false,
    this.isPrimary = false,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      accountHolder: json['accountHolder'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      ifscCode: json['ifscCode'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'accountHolder': accountHolder,
        'accountNumber': accountNumber, // already encrypted
        'ifscCode': ifscCode,
        'bankName': bankName,
        'branchName': branchName,
        'isVerified': isVerified,
        'isPrimary': isPrimary,
      };

  /// Last 4 digits for masked display (only if plaintext was set).
  String get maskedNumber {
    if (accountNumber.length <= 4) return accountNumber;
    // If stored decrypted locally we can show last 4; encrypted values
    // should be decrypted first. The UI passes the decrypted number.
    return 'XXXX XXXX ${accountNumber.substring(accountNumber.length - 4)}';
  }

  BankDetailsModel copyWith({
    String? accountHolder,
    String? accountNumber,
    String? ifscCode,
    String? bankName,
    String? branchName,
    bool? isVerified,
    bool? isPrimary,
  }) {
    return BankDetailsModel(
      accountHolder: accountHolder ?? this.accountHolder,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      isVerified: isVerified ?? this.isVerified,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  @override
  List<Object?> get props => [
        accountHolder,
        accountNumber,
        ifscCode,
        bankName,
        isVerified,
      ];
}
