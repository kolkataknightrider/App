// ════════════════════════════════════════════════════════════════
// FILE: lib/features/withdrawal/screens/withdrawal_history_screen.dart
// SECTION 10 — withdrawal history (timeline view).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/empty_state_widget.dart';
import 'package:partix/core/models/withdrawal_model.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:partix/core/utils/date_formatter.dart';
import 'package:partix/features/withdrawal/widgets/withdrawal_history_card.dart';

class WithdrawalHistoryScreen extends ConsumerStatefulWidget {
  const WithdrawalHistoryScreen({super.key});

  @override
  ConsumerState<WithdrawalHistoryScreen> createState() =>
      _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState
    extends ConsumerState<WithdrawalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = AuthService.instance.currentUid;
      if (uid != null) ref.read(withdrawalProvider).watchHistory(uid);
    });
  }

  final _filters = ['All', 'Pending', 'Processing', 'Completed', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    final withdrawal = ref.watch(withdrawalProvider);
    final items = withdrawal.filteredHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.withdrawalHistory),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: withdrawal.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Filter chips ──
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final f = _filters[i];
                      final active = withdrawal.filter == _filterEnum(f);
                      return ChoiceChip(
                        label: Text(f),
                        selected: active,
                        selectedColor: AppColors.brandPrimary,
                        labelStyle: TextStyle(
                          color:
                              active ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        onSelected: (_) => withdrawal.setFilter(_filterEnum(f)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // ── Timeline ──
                Expanded(
                  child: items.isEmpty
                      ? const EmptyStateWidget(message: 'No withdrawal records')
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.md),
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            final w = items[i];
                            final isFirst = i == 0;
                            final isLast = i == items.length - 1;
                            final dotColor = _statusColor(w.status);
                            return TimelineTile(
                              alignment: TimelineAlign.start,
                              isFirst: isFirst,
                              isLast: isLast,
                              indicatorStyle: IndicatorStyle(
                                width: 16,
                                color: dotColor,
                                padding: const EdgeInsets.all(6),
                              ),
                              beforeLineStyle: const LineStyle(
                                color: AppColors.darkBorder,
                                thickness: 2,
                              ),
                              endChild: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16, left: 12),
                                child: WithdrawalHistoryCard(
                                  withdrawal: w,
                                  onCancel: () => ref
                                      .read(withdrawalProvider)
                                      .cancel(w.withdrawalId),
                                  onRetry: () =>
                                      context.go(AppRoutes.withdrawal),
                                  onDownload: () => _shareReceipt(w),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  /// Builds a plain-text payout receipt and opens the share sheet.
  void _shareReceipt(WithdrawalModel w) {
    final target = w.method == 'upi'
        ? 'UPI: ${w.paymentDetails.upiId ?? '-'}'
        : '${w.paymentDetails.bankName ?? 'Bank'} '
            'a/c ****${w.paymentDetails.accountNumber ?? ''}';
    final receipt = '''
PARTIX — Withdrawal Receipt
────────────────────────────
Member    : ${w.memberName} (${w.memberId})
Amount    : ${CurrencyFormatter.format(w.amount)}
Method    : ${w.method.toUpperCase()}
Paid to   : $target
Status    : ${w.status.toUpperCase()}
Requested : ${DateFormatter.mediumWithTime(w.requestedAt)}
Paid on   : ${w.processedAt == null ? '-' : DateFormatter.mediumWithTime(w.processedAt!)}
Txn ID    : ${w.transactionId ?? '-'}
Ref       : ${w.withdrawalId}
────────────────────────────
Generated by the PARTIX app''';
    Share.share(receipt, subject: 'PARTIX withdrawal receipt');
  }

  WithdrawalStatusFilter _filterEnum(String label) {
    switch (label) {
      case 'Pending':
        return WithdrawalStatusFilter.pending;
      case 'Processing':
        return WithdrawalStatusFilter.processing;
      case 'Completed':
        return WithdrawalStatusFilter.completed;
      case 'Rejected':
        return WithdrawalStatusFilter.rejected;
      default:
        return WithdrawalStatusFilter.all;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }
}
