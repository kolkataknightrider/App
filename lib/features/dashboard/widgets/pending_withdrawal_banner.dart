// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/pending_withdrawal_banner.dart
// SECTION 7 — conditional pending-withdrawal alert.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/models/withdrawal_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

class PendingWithdrawalBanner extends StatelessWidget {
  final WithdrawalModel withdrawal;
  const PendingWithdrawalBanner({super.key, required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top_rounded,
              color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1 Withdrawal Pending — ${CurrencyFormatter.format(withdrawal.amount)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  'Requested ${DateFormatter.timeAgo(withdrawal.requestedAt)}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                context.go(AppRoutes.withdrawalHistory),
            child: const Text('Check Status →'),
          ),
        ],
      ),
    );
  }
}
