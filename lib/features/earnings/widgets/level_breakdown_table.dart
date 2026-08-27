// ════════════════════════════════════════════════════════════════
// FILE: lib/features/earnings/widgets/level_breakdown_table.dart
// SECTION 9 — level breakdown table.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/earning_model.dart';
import '../../../../core/services/mlm_calculator.dart';
import '../../../../core/utils/currency_formatter.dart';

class LevelBreakdownTable extends StatelessWidget {
  final Map<int, LevelBreakdown> breakdown;
  final double total;
  const LevelBreakdownTable({
    super.key,
    required this.breakdown,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final rows = breakdown.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Level Breakdown',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.4),
              3: FlexColumnWidth(1.4),
            },
            border: TableBorder.all(color: AppColors.darkBorder, width: 0.5),
            children: [
              _headerRow(),
              ...rows.map((e) => _dataRow(
                    'L${e.key}',
                    '${e.value.transactions}',
                    '${e.value.transactions}',
                    e.value.amount,
                  )),
              _totalRow(rows),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _headerRow() => TableRow(
        decoration: const BoxDecoration(color: AppColors.darkBgTertiary),
        children: const [
          _Cell('Level', bold: true),
          _Cell('Members', bold: true),
          _Cell('Txns', bold: true),
          _Cell('Amount', bold: true),
        ],
      );

  TableRow _dataRow(
      String level, String members, String txns, double amount) {
    return TableRow(
      children: [
        _Cell(level),
        _Cell(members),
        _Cell(txns),
        _Cell(CurrencyFormatter.format(amount)),
      ],
    );
  }

  TableRow _totalRow(List<MapEntry<int, LevelBreakdown>> rows) {
    final members = rows.fold(0, (s, e) => s + e.value.transactions);
    final txns = rows.fold(0, (s, e) => s + e.value.transactions);
    return TableRow(
      decoration: const BoxDecoration(color: AppColors.darkBgTertiary),
      children: [
        const _Cell('TOTAL', bold: true),
        _Cell('$members', bold: true),
        _Cell('$txns', bold: true),
        _Cell(CurrencyFormatter.format(total), bold: true),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  const _Cell(this.text, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      );
}
