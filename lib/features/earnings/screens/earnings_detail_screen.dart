// ════════════════════════════════════════════════════════════════
// FILE: lib/features/earnings/screens/earnings_detail_screen.dart
// SECTION 9 — complete earnings detail screen.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/firebase/auth_service.dart';
import '../../../../core/models/earning_model.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/period_selector_bar.dart';
import '../widgets/earnings_type_card.dart';
import '../widgets/level_breakdown_table.dart';
import '../widgets/earnings_transaction_item.dart';

class EarningsDetailScreen extends ConsumerStatefulWidget {
  const EarningsDetailScreen({super.key});

  @override
  ConsumerState<EarningsDetailScreen> createState() =>
      _EarningsDetailScreenState();
}

class _EarningsDetailScreenState
    extends ConsumerState<EarningsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = AuthService.instance.currentUid;
      if (uid != null) ref.read(earningsProvider).watchEarnings(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(earningsProvider);
    final user = ref.watch(userProvider).user;
    final periodEarnings = provider.periodEarnings;
    final total = provider.periodTotal;

    // Group by type for the type cards.
    final Map<String, _TypeSummary> byType = {};
    for (final e in periodEarnings) {
      final s = byType.putIfAbsent(
          e.type, () => _TypeSummary(e.typeLabel, 0, 0));
      s.amount += e.amount;
      s.count += 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.earnings),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PeriodSelectorBar(),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Total for period ──
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${AppStrings.totalEarned} — ${provider.periodLabel()}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.format(total),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'From ${periodEarnings.length} transactions',
                          style: const TextStyle(
                              color: AppColors.textTertiary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Earnings by type (horizontal) ──
                  const Text(AppStrings.earningsByType,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: byType.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final entry = byType.entries.elementAt(i);
                        final s = entry.value;
                        final percent = total > 0
                            ? (s.amount / total) * 100
                            : 0.0;
                        return EarningsTypeCard(
                          label: s.label,
                          amount: s.amount,
                          count: s.count,
                          percent: percent,
                          icon: _iconForType(s.label),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Level breakdown table ──
                  LevelBreakdownTable(
                    breakdown: provider.levelBreakdown,
                    total: total,
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Transactions ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(AppStrings.transactions,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      TextButton(
                        onPressed: () async {
                          if (user == null) return;
                          await PdfService.generateAndOpen(
                            user: user,
                            earnings: periodEarnings,
                            periodLabel: provider.periodLabel(),
                            total: total,
                          );
                        },
                        child: const Text(AppStrings.downloadPdf),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (periodEarnings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No transactions in this period',
                            style:
                                TextStyle(color: AppColors.textSecondary)),
                      ),
                    )
                  else
                    ...periodEarnings
                        .take(20)
                        .map((e) => EarningsTransactionItem(earning: e))
                        .toList(),
                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
    );
  }

  IconData _iconForType(String label) {
    if (label.contains('L1')) return Icons.looks_one;
    if (label.contains('L2')) return Icons.looks_two;
    if (label.contains('L3')) return Icons.looks_3;
    if (label.contains('L4')) return Icons.looks_4;
    if (label.contains('L5')) return Icons.looks_5;
    if (label.contains('Rank')) return Icons.military_tech;
    return Icons.paid;
  }
}

class _TypeSummary {
  final String label;
  double amount;
  int count;
  _TypeSummary(this.label, this.amount, this.count);
}
