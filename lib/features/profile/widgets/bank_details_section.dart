// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/bank_details_section.dart
// SECTION 11 — bank account management (encrypted at rest).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/bank_details_model.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/encryption_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../../../shared/widgets/status_badge.dart';

class BankDetailsSection extends ConsumerStatefulWidget {
  final UserModel user;
  const BankDetailsSection({super.key, required this.user});

  @override
  ConsumerState<BankDetailsSection> createState() =>
      _BankDetailsSectionState();
}

class _BankDetailsSectionState extends ConsumerState<BankDetailsSection> {
  final _holder = TextEditingController();
  final _number = TextEditingController();
  final _ifsc = TextEditingController();
  final _bank = TextEditingController();
  final _branch = TextEditingController();

  @override
  void dispose() {
    _holder.dispose();
    _number.dispose();
    _ifsc.dispose();
    _bank.dispose();
    _branch.dispose();
    super.dispose();
  }

  void _openDialog() {
    final b = widget.user.bankDetails;
    _holder.text = b?.accountHolder ?? '';
    _number.text = b != null ? EncryptionHelper.decrypt(b.accountNumber) : '';
    _ifsc.text = b?.ifscCode ?? '';
    _bank.text = b?.bankName ?? '';
    _branch.text = b?.branchName ?? '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(b == null ? 'Add Bank Account' : 'Edit Bank Account'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tf('Account Holder', _holder),
              _tf('Account Number', _number),
              _tf('IFSC', _ifsc),
              _tf('Bank Name', _bank),
              _tf('Branch', _branch),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }

  Widget _tf(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(
          controller: c,
          decoration: InputDecoration(labelText: label),
        ),
      );

  Future<void> _save() async {
    if (Validators.validateRequired(_holder.text, 'Holder') != null ||
        Validators.validateIfsc(_ifsc.text) != null ||
        Validators.validateRequired(_bank.text, 'Bank') != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill valid details')));
      return;
    }
    // Encrypt the account number before storage.
    final encrypted = EncryptionHelper.encrypt(_number.text.trim());
    final bank = BankDetailsModel(
      accountHolder: _holder.text.trim(),
      accountNumber: encrypted,
      ifscCode: _ifsc.text.trim().toUpperCase(),
      bankName: _bank.text.trim(),
      branchName: _branch.text.trim(),
      isVerified: false,
    );
    await ref.read(userProvider).updateBank(bank);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank details saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bank = widget.user.bankDetails;
    return SectionCard(
      title: AppStrings.bankAccount,
      trailing: TextButton(
        onPressed: _openDialog,
        child: const Text('Edit'),
      ),
      child: bank == null
          ? const Text('No bank account added',
              style: TextStyle(color: AppColors.textSecondary))
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${bank.bankName} · ${bank.maskedNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('IFSC: ${bank.ifscCode}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                StatusBadge.status(bank.isVerified ? 'verified' : 'pending'),
              ],
            ),
    );
  }
}
