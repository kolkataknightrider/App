// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/earnings_chart_widget.dart
// SECTION 7 — earnings trend chart with daily/weekly/monthly toggle.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/services/mlm_calculator.dart';
import 'package:partix/core/models/earning_model.dart';
import 'package:partix/core/utils/currency_formatter.dart';

class EarningsChartWidget extends StatefulWidget {
  final List<EarningModel> earnings;
  const EarningsChartWidget({super.key, required this.earnings});

  @override
  State<EarningsChartWidget> createState() => _EarningsChartWidgetState();
}

class _EarningsChartWidgetState extends State<EarningsChartWidget> {
  int _rangeIndex = 1; // 0 daily, 1 weekly, 2 monthly
  final _ranges = ['Daily', 'Weekly', 'Monthly'];

  List<double> _series() {
    final now = DateTime.now();
    if (_rangeIndex == 1) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return MLMCalculator.weeklySeries(widget.earnings, weekStart);
    } else if (_rangeIndex == 2) {
      // last 6 months
      final series = <double>[];
      for (int i = 5; i >= 0; i--) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 1);
        series.add(MLMCalculator.totalInRange(widget.earnings, monthStart,
            monthEnd.subtract(const Duration(milliseconds: 1))));
      }
      return series;
    } else {
      // last 7 days
      final series = <double>[];
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final next = day.add(const Duration(days: 1));
        series.add(MLMCalculator.totalInRange(widget.earnings, day,
            next.subtract(const Duration(milliseconds: 1))));
      }
      return series;
    }
  }

  @override
  Widget build(BuildContext context) {
    final series = _series();
    final labels = _rangeIndex == 2
        ? ['M-5', 'M-4', 'M-3', 'M-2', 'M-1', 'Now']
        : _rangeIndex == 1
            ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
            : ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'D-1', 'Now'];

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
              const Text('Earnings Trend',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: _ranges.asMap().entries.map((e) {
                    final active = _rangeIndex == e.key;
                    return GestureDetector(
                      onTap: () => setState(() => _rangeIndex = e.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.brandPrimary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                active ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _max(series) / 4,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: AppColors.darkBorder.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(labels[i],
                            style: const TextStyle(
                                fontSize: 9, color: AppColors.textTertiary));
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, _) => Text(
                        CurrencyFormatter.compact(v),
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: series
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    gradient: AppColors.brandGradient,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.brandPrimary.withOpacity(0.3),
                          AppColors.brandAccent.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _max(List<double> s) {
    final m = s.reduce((a, b) => a > b ? a : b);
    return m <= 0 ? 100 : m;
  }
}
