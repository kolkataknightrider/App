// ════════════════════════════════════════════════════════════════
// FILE: lib/features/earnings/widgets/earnings_type_card.dart
// SECTION 9 — horizontal scrolling earnings-by-type cards.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/utils/currency_formatter.dart';

class EarningsTypeCard extends StatelessWidget {
  final String label;
  final double amount;
  final int count;
  final double percent;
  final IconData icon;

  const EarningsTypeCard({
    super.key,
    required this.label,
    required this.amount,
    required this.count,
    required this.percent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.brandPrimary, size: 22),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(amount),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text('From $count joinings',
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            percent: (percent / 100).clamp(0.0, 1.0),
            lineHeight: 6,
            backgroundColor: AppColors.darkBorder,
            progressColor: AppColors.brandAccent,
            barRadius: const Radius.circular(6),
            padding: EdgeInsets.zero,
            trailing: Text('${percent.toInt()}%',
                style: const TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
