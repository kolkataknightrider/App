// ════════════════════════════════════════════════════════════════
// FILE: lib/features/withdrawal/screens/withdrawal_screen.dart
// SECTION 10 — withdrawal request screen.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/mlm_config.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/utils/validators.dart';
import 'package:partix/shared/widgets/custom_button.dart';
import 'package:partix/shared/widgets/error_state_widget.dart';
import 'package:partix/features/withdrawal/widgets/balance_header_card.dart';
import 'package:partix/features/withdrawal/widgets/amount_input_widget.dart';
import 'package:partix/features/withdrawal/widgets/payment_method_selector.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final _amountCtrl = TextEditingController();
  String _method = 'upi';
  Map<String, dynamic> _details = {};
  bool _initialized = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).user;
    final withdrawal = ref.watch(withdrawalProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_initialized) {
      _initialized = true;
    }

    final eligible = withdrawal.isEligible(user);
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final label = amount > 0
        ? '${AppStrings.requestWithdrawal} → ₹$amount'
        : AppStrings.requestWithdrawal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wallet),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceHeaderCard(
              user: user,
              usedSlots: user.withdrawalCountThisMonth,
            ),
            const SizedBox(height: AppDimensions.lg),

            AmountInputWidget(
              controller: _amountCtrl,
              maxAmount: user.availableBalance,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppDimensions.lg),

            PaymentMethodSelector(
              user: user,
              onChanged: (m, d) {
                _method = m;
                _details = d;
              },
            ),
            const SizedBox(height: AppDimensions.lg),

            // ── Processing info ──
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'UPI: processed within 24h. Bank: 2–3 business days. '
                      'Manual approval by Partix Admin required.',
                      style: TextStyle(fontSize: 11, color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // ── Eligibility message ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: eligible
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                withdrawal.eligibilityMessage(user),
                style: TextStyle(
                  fontSize: 12,
                  color: eligible ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            if (withdrawal.error != null)
              ErrorStateWidget(
                message: withdrawal.error.toString(),
                onRetry: () => setState(() {}),
              ),

            CustomButton(
              label: label,
              isLoading: withdrawal.submitting,
              enabled:
                  eligible && amount > 0 && amount <= user.availableBalance,
              onPressed: () => _confirm(user, withdrawal),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  /// Validates, confirms and submits the withdrawal request.
  /// Uses the State's own [context]/[mounted] pair so post-await guards
  /// are analyser-safe.
  Future<void> _confirm(UserModel user, WithdrawalProvider withdrawal) async {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final err = Validators.validateAmount(_amountCtrl.text,
        maxAllowed: user.availableBalance);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.confirmWithdrawal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${CurrencyFormatter.format(amount)}'),
            Text('Method: ${_method == 'upi' ? 'UPI' : 'Bank'} — '
                '${_details.values.join(', ')}'),
            const SizedBox(height: 8),
            const Text(
                'Processing: Within 24 hours (subject to admin approval)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm & Submit'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await withdrawal.requestWithdrawal(
        user: user,
        amount: amount,
        method: _method,
        paymentDetails: _details,
        periodLabel: MLMConfig.periodLabel(DateTime.now()),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Withdrawal request submitted!'),
            backgroundColor: AppColors.success,
          ),
        );
        _amountCtrl.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}
