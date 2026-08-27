// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/recent_activity_list.dart
// SECTION 7 — recent earnings activity feed.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/models/earning_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

class RecentActivityList extends StatelessWidget {
  final List<EarningModel> items;
  const RecentActivityList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text(AppStrings.recentActivity,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
              TextButton(
                  onPressed: () => context.go(AppRoutes.earnings),
                  child: const Text('${AppStrings.viewAll} →')),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                  child: Text('No recent earnings',
                      style: TextStyle(color: AppColors.textSecondary))),
            )
          else
            ...items.map((e) => _activityTile(e)).toList(),
        ],
      ),
    );
  }

  Widget _activityTile(EarningModel e) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.paid_rounded,
                color: AppColors.success, size: 20),
          ),
          title: Text(e.typeLabel,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(
            '${e.fromUserName} joined (L${e.level})',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+ ${CurrencyFormatter.format(e.amount)}',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Text(
                DateFormatter.relative(e.date),
                style: const TextStyle(
                    color: AppColors.textTertiary, fontSize: 10),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
