// ════════════════════════════════════════════════════════════════
// PARTIX — unit tests for MLM business rules.
// ════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:partix/core/constants/mlm_config.dart';

void main() {
  group('MLMConfig commission', () {
    test('joining fee is ₹199', () {
      expect(MLMConfig.joiningFee, 199.0);
    });

    test('L1 commission is 20% of ₹199', () {
      expect(MLMConfig.calculateCommission(1),
          closeTo(199 * 0.20, 0.001));
    });

    test('L5 commission is 3% of ₹199', () {
      expect(MLMConfig.calculateCommission(5),
          closeTo(199 * 0.03, 0.001));
    });

    test('unknown level yields zero commission', () {
      expect(MLMConfig.calculateCommission(99), 0.0);
    });

    test('full network total matches spec (₹89.55)', () {
      final total = MLMConfig.calculateCommission(1) +
          MLMConfig.calculateCommission(2) +
          MLMConfig.calculateCommission(3) +
          MLMConfig.calculateCommission(4) +
          MLMConfig.calculateCommission(5);
      expect(total, closeTo(89.55, 0.01));
    });
  });

  group('MLMConfig withdrawal rules', () {
    final now = DateTime(2025, 1, 10);

    test('eligible when gap satisfied and under monthly limit', () {
      final last = now.subtract(const Duration(days: 20));
      expect(
        MLMConfig.isWithdrawalEligible(
          lastWithdrawalDate: last,
          withdrawalCountThisMonth: 0,
        ),
        isTrue,
      );
    });

    test('not eligible when gap too short', () {
      final last = now.subtract(const Duration(days: 3));
      expect(
        MLMConfig.isWithdrawalEligible(
          lastWithdrawalDate: last,
          withdrawalCountThisMonth: 0,
        ),
        isFalse,
      );
    });

    test('not eligible after 2 withdrawals this month', () {
      expect(
        MLMConfig.isWithdrawalEligible(
          lastWithdrawalDate: now.subtract(const Duration(days: 30)),
          withdrawalCountThisMonth: 2,
        ),
        isFalse,
      );
    });

    test('next eligible date is 15 days after last', () {
      final last = DateTime(2025, 1, 1);
      final next = MLMConfig.nextEligibleWithdrawalDate(last);
      expect(next, DateTime(2025, 1, 16));
    });
  });

  group('MLMConfig ranks', () {
    test('associate at 0 team / 0 earnings', () {
      final rank = MLMConfig.getCurrentRank(
        teamSize: 0,
        careerEarnings: 0,
      );
      expect(rank['name'], 'Associate');
    });

    test('manager at 30 team / 20000 earnings', () {
      final rank = MLMConfig.getCurrentRank(
        teamSize: 30,
        careerEarnings: 20000,
      );
      expect(rank['name'], 'Manager');
    });

    test('president at 600 team / 600000 earnings', () {
      final rank = MLMConfig.getCurrentRank(
        teamSize: 600,
        careerEarnings: 600000,
      );
      expect(rank['name'], 'President');
    });
  });
}
