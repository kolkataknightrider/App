// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/withdrawal_provider.dart
// Withdrawal eligibility engine + history + request (SECTION 10).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import '../constants/mlm_config.dart';
import '../firebase/firestore_service.dart';
import '../models/user_model.dart';
import '../models/withdrawal_model.dart';
import '../utils/date_formatter.dart';
import 'dart:math';

enum WithdrawalStatusFilter { all, pending, processing, completed, rejected }

class WithdrawalProvider extends ChangeNotifier {
  List<WithdrawalModel> _history = const [];
  bool _loading = false;
  Object? _error;
  bool _submitting = false;
  WithdrawalStatusFilter _filter = WithdrawalStatusFilter.all;

  List<WithdrawalModel> get history => _history;
  bool get loading => _loading;
  Object? get error => _error;
  bool get submitting => _submitting;
  WithdrawalStatusFilter get filter => _filter;

  final FirestoreService _firestore = FirestoreService.instance;

  void watchHistory(String userId) {
    _loading = true;
    notifyListeners();
    _firestore.streamWithdrawals(userId).listen((list) {
      _history = list;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _loading = false;
      _error = e;
      notifyListeners();
    });
  }

  void setFilter(WithdrawalStatusFilter f) {
    _filter = f;
    notifyListeners();
  }

  List<WithdrawalModel> get filteredHistory {
    if (_filter == WithdrawalStatusFilter.all) return _history;
    return _history.where((w) => w.status == _filter.name).toList();
  }

  /// Whether a withdrawal can be submitted right now.
  bool isEligible(UserModel user) {
    final last = user.lastWithdrawalDate ??
        DateTime.now().subtract(
            const Duration(days: MLMConfig.withdrawalGapDays + 1));
    return MLMConfig.isWithdrawalEligible(
      lastWithdrawalDate: last,
      withdrawalCountThisMonth: user.withdrawalCountThisMonth,
    );
  }

  /// Days remaining until eligible again (0 if eligible now).
  int daysUntilEligible(UserModel user) {
    final last = user.lastWithdrawalDate ??
        DateTime.now().subtract(
            const Duration(days: MLMConfig.withdrawalGapDays + 1));
    if (user.withdrawalCountThisMonth >= MLMConfig.maxWithdrawalsPerMonth) {
      // next month reset
      final nextMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
      return nextMonth.difference(DateTime.now()).inDays;
    }
    final next = MLMConfig.nextEligibleWithdrawalDate(last);
    return max(0, next.difference(DateTime.now()).inDays);
  }

  /// Friendly eligibility message for the UI.
  String eligibilityMessage(UserModel user) {
    if (user.withdrawalCountThisMonth >= MLMConfig.maxWithdrawalsPerMonth) {
      final nextMonth =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
      return 'Withdrawal limit reached for this month. Next window opens ${DateFormatter.medium(nextMonth)}.';
    }
    if (!isEligible(user)) {
      final days = daysUntilEligible(user);
      final next = MLMConfig.nextEligibleWithdrawalDate(
          user.lastWithdrawalDate ??
              DateTime.now());
      return 'Your next withdrawal is available in $days days. Eligible from: ${DateFormatter.medium(next)}.';
    }
    return 'You can withdraw now. ${user.withdrawalCountThisMonth} of 2 slots used this month.';
  }

  /// Submits a withdrawal request. Throws on validation failure.
  Future<void> requestWithdrawal({
    required UserModel user,
    required double amount,
    required String method,
    required Map<String, dynamic> paymentDetails,
    required String periodLabel,
  }) async {
    if (!isEligible(user)) {
      throw Exception('Withdrawal not eligible at this time.');
    }
    if (amount > user.availableBalance) {
      throw Exception('Amount exceeds available balance.');
    }
    _submitting = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final withdrawalId =
          'WD-${now.year}-${_random6()}'; // Cloud Functions should assign.
      final count = user.withdrawalCountThisMonth + 1;
      await _firestore.createWithdrawal({
        'withdrawalId': withdrawalId,
        'userId': user.uid,
        'memberId': user.memberId,
        'memberName': user.fullName,
        'amount': amount,
        'method': method,
        'paymentDetails': paymentDetails,
        'status': 'pending',
        'requestedAt': now.millisecondsSinceEpoch,
        'withdrawalCount': count,
        'periodLabel': periodLabel,
      });
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  Future<void> cancel(String withdrawalId) async {
    await _firestore.cancelWithdrawal(withdrawalId);
  }

  String _random6() {
    final rnd = Random();
    return List.generate(6, (_) => rnd.nextInt(10)).join();
  }
}
