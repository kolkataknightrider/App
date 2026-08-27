// ════════════════════════════════════════════════════════════════
// FILE: lib/features/earnings/widgets/earnings_transaction_item.dart
// SECTION 9 — single transaction row.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/models/earning_model.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:partix/core/utils/date_formatter.dart';

class EarningsTransactionItem extends StatelessWidget {
  final EarningModel earning;
  const EarningsTransactionItem({super.key, required this.earning});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.paid_rounded,
                color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(earning.typeLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '${earning.fromUserName} (${earning.fromMemberId})',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                Text(
                  'Joining Fee: ₹${earning.baseAmount.toInt()} × '
                  '${(earning.commissionRate * 100).toInt()}%',
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+ ${CurrencyFormatter.format(earning.amount)}',
                  style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              Text(DateFormatter.mediumWithTime(earning.date),
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
