// ════════════════════════════════════════════════════════════════
// PARTIX — unit tests for the commission calculator.
// ════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:partix/core/models/earning_model.dart';
import 'package:partix/core/services/mlm_calculator.dart';

List<EarningModel> _sample() => [
      EarningModel(
        earningId: '1',
        type: 'direct_referral',
        amount: 39.8,
        fromUserId: 'u1',
        fromUserName: 'A',
        fromMemberId: 'PTX1',
        level: 1,
        commissionRate: 0.2,
        baseAmount: 199,
        description: '',
        date: DateTime(2025, 1, 1),
        month: '2025-01',
        week: '2025-W01',
      ),
      EarningModel(
        earningId: '2',
        type: 'level_2_commission',
        amount: 19.9,
        fromUserId: 'u2',
        fromUserName: 'B',
        fromMemberId: 'PTX2',
        level: 2,
        commissionRate: 0.1,
        baseAmount: 199,
        description: '',
        date: DateTime(2025, 1, 2),
        month: '2025-01',
        week: '2025-W01',
      ),
    ];

void main() {
  test('totalEarnings sums all credited amounts', () {
    expect(MLMCalculator.totalEarnings(_sample()), closeTo(59.7, 0.001));
  });

  test('breakdownByLevel groups by level', () {
    final bd = MLMCalculator.breakdownByLevel(_sample());
    expect(bd[1]!.amount, closeTo(39.8, 0.001));
    expect(bd[2]!.amount, closeTo(19.9, 0.001));
    expect(bd[1]!.transactions, 1);
  });

  test('totalByType groups by type', () {
    final byType = MLMCalculator.totalByType(_sample());
    expect(byType['direct_referral'], closeTo(39.8, 0.001));
    expect(byType['level_2_commission'], closeTo(19.9, 0.001));
  });

  test('percentOf computes ratio', () {
    expect(MLMCalculator.percentOf(50, 200), 25.0);
    expect(MLMCalculator.percentOf(10, 0), 0.0);
  });
}
