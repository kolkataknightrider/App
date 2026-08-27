// ════════════════════════════════════════════════════════════════
// FILE: lib/core/services/mlm_calculator.dart
// Commission calculation & earnings aggregation.
// ════════════════════════════════════════════════════════════════

import '../constants/mlm_config.dart';
import '../models/earning_model.dart';

/// Pure functions for MLM math. No side effects, easy to unit-test.
class MLMCalculator {
  MLMCalculator._();

  /// Commission for a single joiner at a given [level].
  static double commissionForLevel(int level) =>
      MLMConfig.calculateCommission(level);

  /// Total a user earns if one person joins at each of levels 1..5.
  static double totalForFullNetwork() {
    double sum = 0;
    for (int l = 1; l <= 5; l++) sum += commissionForLevel(l);
    return sum;
  }

  /// Sum of all credited earnings.
  static double totalEarnings(List<EarningModel> earnings) {
    return earnings
        .where((e) => e.status == 'credited')
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Sum of earnings within a date range (inclusive bounds).
  static double totalInRange(
    List<EarningModel> earnings,
    DateTime start,
    DateTime end,
  ) {
    return earnings
        .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Aggregated totals grouped by MLM level.
  static Map<int, LevelBreakdown> breakdownByLevel(
      List<EarningModel> earnings) {
    final map = <int, LevelBreakdown>{};
    for (final e in earnings) {
      final entry = map.putIfAbsent(
        e.level,
        () => LevelBreakdown(level: e.level),
      );
      entry.transactions += 1;
      entry.amount += e.amount;
    }
    return map;
  }

  /// Aggregated totals grouped by earning type.
  static Map<String, double> totalByType(List<EarningModel> earnings) {
    final map = <String, double>{};
    for (final e in earnings) {
      map[e.type] = (map[e.type] ?? 0) + e.amount;
    }
    return map;
  }

  /// Percentage of total that a single type represents (0..100).
  static double percentOf(double part, double total) {
    if (total <= 0) return 0;
    return (part / total) * 100;
  }

  /// Builds a daily total series for a week (Mon..Sun) from earnings.
  static List<double> weeklySeries(List<EarningModel> earnings, DateTime weekStart) {
    final series = List.filled(7, 0.0);
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final next = day.add(const Duration(days: 1));
      series[i] = totalInRange(earnings, day, next.subtract(const Duration(milliseconds: 1)));
    }
    return series;
  }
}

/// Aggregated totals for a single MLM level.
class LevelBreakdown {
  final int level;
  int transactions = 0;
  double amount = 0.0;

  LevelBreakdown({required this.level});

  String get label => 'L$level';
}
