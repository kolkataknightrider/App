// ════════════════════════════════════════════════════════════════
// FILE: lib/features/earnings/widgets/period_selector_bar.dart
// SECTION 9 — Today / Week / Month / Last Month / Custom selector.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/providers/providers.dart';

class PeriodSelectorBar extends ConsumerWidget {
  const PeriodSelectorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(earningsProvider);
    final tabs = [
      const _Tab('Today', EarningPeriod.today),
      const _Tab('This Week', EarningPeriod.week),
      const _Tab('This Month', EarningPeriod.month),
      const _Tab('Last Month', EarningPeriod.lastMonth),
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final t = tabs[i];
          final active = provider.period == t.period;
          return GestureDetector(
            onTap: () => provider.setPeriod(t.period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: active ? AppColors.brandGradient : null,
                color: active ? null : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                border: active ? null : Border.all(color: AppColors.darkBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                t.label,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tab {
  final String label;
  final EarningPeriod period;
  const _Tab(this.label, this.period);
}
