// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/earnings_provider.dart
// Earnings detail: period, type breakdown, filters (SECTION 9).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import '../firebase/firestore_service.dart';
import '../models/earning_model.dart';
import '../services/mlm_calculator.dart';
import '../utils/date_formatter.dart';

enum EarningPeriod { today, week, month, lastMonth, custom }

class EarningsProvider extends ChangeNotifier {
  List<EarningModel> _earnings = const [];
  bool _loading = false;
  Object? _error;
  EarningPeriod _period = EarningPeriod.month;
  DateTime? _customStart;
  DateTime? _customEnd;

  List<EarningModel> get earnings => _earnings;
  bool get loading => _loading;
  Object? get error => _error;
  EarningPeriod get period => _period;
  DateTime? get customStart => _customStart;
  DateTime? get customEnd => _customEnd;

  final FirestoreService _firestore = FirestoreService.instance;

  void watchEarnings(String userId) {
    _loading = true;
    notifyListeners();
    _firestore.streamEarnings(userId).listen((list) {
      _earnings = list;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _loading = false;
      _error = e;
      notifyListeners();
    });
  }

  void setPeriod(EarningPeriod period) {
    _period = period;
    notifyListeners();
  }

  void setCustomRange(DateTime start, DateTime end) {
    _customStart = start;
    _customEnd = end;
    _period = EarningPeriod.custom;
    notifyListeners();
  }

  /// Date range for the active period.
  (DateTime, DateTime) get periodRange {
    final now = DateTime.now();
    switch (_period) {
      case EarningPeriod.today:
        final start = DateTime(now.year, now.month, now.day);
        return (start, start.add(const Duration(days: 1)));
      case EarningPeriod.week:
        final start = now.subtract(const Duration(days: 7));
        return (start, now);
      case EarningPeriod.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month, 1);
        return (start, end);
      case EarningPeriod.custom:
        return (
          _customStart ?? now.subtract(const Duration(days: 30)),
          _customEnd ?? now
        );
      case EarningPeriod.month:
      default:
        final start = DateTime(now.year, now.month, 1);
        return (start, now);
    }
  }

  /// Earnings within the active period.
  List<EarningModel> get periodEarnings {
    final (start, end) = periodRange;
    final endInclusive = end.add(const Duration(milliseconds: -1));
    return _earnings
        .where((e) => !e.date.isBefore(start) && !e.date.isAfter(endInclusive))
        .toList();
  }

  double get periodTotal => MLMCalculator.totalEarnings(periodEarnings);

  int get periodTxCount => periodEarnings.length;

  Map<int, LevelBreakdown> get levelBreakdown =>
      MLMCalculator.breakdownByLevel(periodEarnings);

  Map<String, double> get byType => MLMCalculator.totalByType(periodEarnings);

  String periodLabel() {
    switch (_period) {
      case EarningPeriod.today:
        return 'Today';
      case EarningPeriod.week:
        return 'This Week';
      case EarningPeriod.lastMonth:
        return 'Last Month';
      case EarningPeriod.custom:
        return 'Custom';
      case EarningPeriod.month:
      default:
        return 'This Month';
    }
  }
}
