// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/dashboard_provider.dart
// Dashboard metrics derived from the user model + earnings.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:partix/core/firebase/firestore_service.dart';
import 'package:partix/core/models/earning_model.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/services/mlm_calculator.dart';
import 'package:partix/core/utils/date_formatter.dart';

class DashboardProvider extends ChangeNotifier {
  List<EarningModel> _earnings = const [];
  bool _loading = false;
  Object? _error;

  List<EarningModel> get earnings => _earnings;
  bool get loading => _loading;
  Object? get error => _error;

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

  /// Time-based greeting (Good Morning/Afternoon/Evening).
  String greeting(UserModel user) {
    final h = DateTime.now().hour;
    final name = user.fullName.split(' ').first;
    if (h < 12) return 'Good Morning, $name';
    if (h < 17) return 'Good Afternoon, $name';
    return 'Good Evening, $name';
  }

  /// Percentage-change helper for metric cards.
  double pctChange(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  /// Recent activity limited to [limit] items.
  List<EarningModel> recentActivity({int limit = 5}) {
    final sorted = [..._earnings]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  /// 7-day series for the trend chart.
  List<double> weeklyTrend() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return MLMCalculator.weeklySeries(_earnings, weekStart);
  }

  String trendLabel(int index) =>
      DateFormatter.weekKey(DateTime.now()).split('-').first;
}
