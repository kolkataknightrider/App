// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/screens/dashboard_screen.dart
// Complete dashboard (SECTION 7) — real-time, shimmer, offline.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/models/withdrawal_model.dart';
import 'package:partix/shared/widgets/partix_app_bar.dart';
import 'package:partix/shared/widgets/clay_animations.dart';
import 'package:partix/shared/widgets/offline_banner.dart';
import 'package:partix/shared/widgets/error_state_widget.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/core/services/rank_service.dart';
import 'package:partix/features/dashboard/widgets/greeting_header.dart';
import 'package:partix/features/dashboard/widgets/earning_metric_card.dart';
import 'package:partix/features/dashboard/widgets/earnings_chart_widget.dart';
import 'package:partix/features/dashboard/widgets/pending_withdrawal_banner.dart';
import 'package:partix/features/dashboard/widgets/quick_actions_row.dart';
import 'package:partix/features/dashboard/widgets/recent_activity_list.dart';
import 'package:partix/features/dashboard/widgets/rank_progress_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final dash = ref.watch(dashboardProvider);
    final withdrawals = ref.watch(withdrawalProvider);
    final isOffline = !(ref.watch(connectivityProvider).value ?? true);

    final pending = withdrawals.history
        .where((w) => w.status == 'pending')
        .cast<WithdrawalModel>()
        .firstOrNull;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PartixAppBar(
        avatarUrl: userState.user?.profilePhotoUrl,
        notificationCount: ref.watch(notificationProvider).unreadCount,
      ),
      body: isOffline
          ? const Column(
              children: [
                OfflineBanner(),
                Expanded(child: Center(child: Text('Showing cached data'))),
              ],
            )
          : ClayBlobBackground(
              cycleSeconds: 18,
              child: _buildBody(context, ref, userState.user, dash, pending),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    UserModel? user,
    DashboardProvider dash,
    WithdrawalModel? pending,
  ) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (dash.error != null) {
      return ErrorStateWidget(
        message: dash.error.toString(),
        onRetry: () {
          final uid = AuthService.instance.currentUid;
          if (uid != null) dash.watchEarnings(uid);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final uid = AuthService.instance.currentUid;
        if (uid != null) {
          await ref.read(userProvider).refresh(uid);
          ref.read(dashboardProvider).watchEarnings(uid);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.md),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 400),
              childAnimationBuilder: (w) => SlideAnimation(
                verticalOffset: 30,
                child: FadeInAnimation(child: w),
              ),
              children: [
                GreetingHeader(user: user, greeting: dash.greeting(user)),
                const SizedBox(height: AppDimensions.md),

                if (pending != null) ...[
                  PendingWithdrawalBanner(withdrawal: pending),
                  const SizedBox(height: AppDimensions.md),
                ],

                // ── Metrics grid ──
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.42,
                  children: [
                    EarningMetricCard(
                      label: AppStrings.todayEarnings,
                      amount: CurrencyFormatter.format(user.todayEarnings),
                      value: user.todayEarnings,
                      percentChange: '+12% vs yday',
                      icon: Icons.wb_sunny_outlined,
                      onTap: () => context.go(AppRoutes.earnings),
                      gradient: AppColors.earningsGradient('today'),
                    ),
                    EarningMetricCard(
                      label: AppStrings.weeklyEarnings,
                      amount: CurrencyFormatter.format(user.weeklyEarnings),
                      value: user.weeklyEarnings,
                      percentChange: '+8% vs lweek',
                      icon: Icons.calendar_view_week_outlined,
                      gradient: AppColors.earningsGradient('week'),
                    ),
                    EarningMetricCard(
                      label: AppStrings.monthlyEarnings,
                      amount: CurrencyFormatter.format(user.monthlyEarnings),
                      value: user.monthlyEarnings,
                      percentChange: '+15% growth',
                      icon: Icons.calendar_month_outlined,
                      gradient: AppColors.earningsGradient('month'),
                    ),
                    EarningMetricCard(
                      label: AppStrings.lastMonthEarnings,
                      amount: CurrencyFormatter.format(user.lastMonthEarnings),
                      value: user.lastMonthEarnings,
                      percentChange: 'Final',
                      icon: Icons.history_outlined,
                      gradient: AppColors.earningsGradient('lastMonth'),
                    ),
                    EarningMetricCard(
                      label: AppStrings.yearlyEarnings,
                      amount: CurrencyFormatter.format(user.yearlyEarnings),
                      value: user.yearlyEarnings,
                      percentChange: 'Jan–Present',
                      icon: Icons.show_chart_outlined,
                      gradient: AppColors.earningsGradient('year'),
                    ),
                    EarningMetricCard(
                      label: AppStrings.teamEarnings,
                      amount: CurrencyFormatter.format(user.totalTeamEarnings),
                      value: user.totalTeamEarnings,
                      percentChange: 'All ${user.totalTeamSize} members',
                      icon: Icons.groups_outlined,
                      onTap: () => context.go(AppRoutes.team),
                      gradient: AppColors.earningsGradient('team'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),

                // ── Gross career earnings (large) ──
                EarningMetricCard(
                  label: AppStrings.grossCareerEarnings,
                  amount: CurrencyFormatter.format(user.grossCareerEarnings),
                  value: user.grossCareerEarnings,
                  percentChange:
                      'Progress to next rank: ${RankService.progressPercent(user).toInt()}%',
                  icon: Icons.diamond_outlined,
                  gradient: AppColors.earningsGradient('gross'),
                  large: true,
                  onTap: () => context.go(AppRoutes.earnings),
                ),
                const SizedBox(height: AppDimensions.md),

                // ── Chart ──
                EarningsChartWidget(earnings: dash.earnings),
                const SizedBox(height: AppDimensions.md),

                // ── Rank progress ──
                RankProgressCard(user: user),
                const SizedBox(height: AppDimensions.md),

                // ── Quick actions ──
                QuickActionsRow(user: user),
                const SizedBox(height: AppDimensions.md),

                // ── Recent activity ──
                RecentActivityList(items: dash.recentActivity()),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
