// ════════════════════════════════════════════════════════════════
// FILE: lib/features/withdrawal/widgets/payment_method_selector.dart
// SECTION 10 — UPI / Bank method selection.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class PaymentMethodSelector extends StatefulWidget {
  final UserModel user;
  final void Function(String method, Map<String, dynamic> details) onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.user,
    required this.onChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String _method = 'upi';

  @override
  void initState() {
    super.initState();
    _emit();
  }

  void _emit() {
    if (_method == 'upi') {
      widget.onChanged('upi', {
        'upiId': widget.user.upiDetails?.upiId ?? '',
      });
    } else {
      final bank = widget.user.bankDetails;
      widget.onChanged('bank', {
        'accountNumber': bank != null ? _last4(bank.accountNumber) : '',
        'bankName': bank?.bankName ?? '',
        'ifscCode': bank?.ifscCode ?? '',
      });
    }
  }

  String _last4(String encryptedOrPlain) {
    if (encryptedOrPlain.length <= 4) return encryptedOrPlain;
    return encryptedOrPlain.substring(encryptedOrPlain.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    final upi = widget.user.upiDetails;
    final bank = widget.user.bankDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.selectPaymentMethod,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // ── UPI ──
        _option(
          selected: _method == 'upi',
          icon: Icons.smartphone,
          title: AppStrings.upiTransfer,
          subtitle: AppStrings.upiRecommended,
          child: upi != null
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(upi.upiId,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(upi.upiName,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    StatusBadge.status('verified'),
                  ],
                )
              : const Text('No UPI added',
                  style: TextStyle(color: AppColors.textTertiary)),
          onTap: () => _select('upi'),
        ),
        const SizedBox(height: 12),

        // ── Bank ──
        _option(
          selected: _method == 'bank',
          icon: Icons.account_balance,
          title: AppStrings.bankTransfer,
          subtitle: '2–3 Business Days',
          child: bank != null
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${bank.bankName} · XXXX ${_last4(bank.accountNumber)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('IFSC: ${bank.ifscCode}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    StatusBadge.status('verified'),
                  ],
                )
              : const Text('No bank account added',
                  style: TextStyle(color: AppColors.textTertiary)),
          onTap: () => _select('bank'),
        ),
      ],
    );
  }

  void _select(String m) {
    setState(() => _method = m);
    _emit();
  }

  Widget _option({
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: selected ? AppColors.brandPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    color: selected
                        ? AppColors.brandPrimary
                        : AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                if (selected)
                  const Icon(Icons.check_circle,
                      color: AppColors.brandPrimary, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textTertiary, fontSize: 11)),
                  const SizedBox(height: 8),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
