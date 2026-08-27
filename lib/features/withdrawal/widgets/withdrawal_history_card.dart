// ════════════════════════════════════════════════════════════════
// FILE: lib/features/withdrawal/widgets/withdrawal_history_card.dart
// SECTION 10 — single withdrawal entry card (used in timeline).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/withdrawal_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/status_badge.dart';

class WithdrawalHistoryCard extends ConsumerWidget {
  final WithdrawalModel withdrawal;
  final VoidCallback? onCancel;
  final VoidCallback? onDownload;
  final VoidCallback? onRetry;

  const WithdrawalHistoryCard({
    super.key,
    required this.withdrawal,
    this.onCancel,
    this.onDownload,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = withdrawal;
    final isUpi = w.method == 'upi';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CurrencyFormatter.format(w.amount),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              StatusBadge.status(w.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isUpi
                ? 'UPI · ${w.paymentDetails.upiId ?? ''}'
                : 'Bank · ${w.paymentDetails.bankName ?? ''}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
          Text(
            'Requested: ${DateFormatter.mediumWithTime(w.requestedAt)}',
            style: const TextStyle(
                color: AppColors.textTertiary, fontSize: 11),
          ),
          if (w.status == 'completed' && w.processedAt != null)
            Text(
              'Completed: ${DateFormatter.mediumWithTime(w.processedAt!)}'
              '${w.transactionId != null ? ' · Txn: ${w.transactionId}' : ''}',
              style: const TextStyle(
                  color: AppColors.textTertiary, fontSize: 11),
            ),
          if (w.status == 'rejected' && w.adminNote != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Reason: ${w.adminNote}',
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 11)),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (w.canCancel && onCancel != null)
                TextButton(
                  onPressed: onCancel,
                  child: const Text(AppStrings.cancelRequest,
                      style: TextStyle(color: AppColors.error)),
                ),
              if (w.status == 'completed' && w.transactionId != null && onDownload != null)
                TextButton(
                  onPressed: onDownload,
                  child: const Text(AppStrings.downloadReceipt),
                ),
              if (w.status == 'rejected' && onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: const Text(AppStrings.retryWithdrawal),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
