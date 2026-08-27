// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/screens/team_screen.dart
// SECTION 8 — Team screen (stats + tree/list toggle).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/firebase/auth_service.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/providers/team_provider.dart'
    show TeamViewMode;
import '../../../../shared/widgets/partix_app_bar.dart';
import '../widgets/team_stats_header.dart';
import '../widgets/team_list_view.dart';
import '../widgets/tree_view_widget.dart';

class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = AuthService.instance.currentUid;
      if (uid != null) ref.read(teamProvider).loadTeamTree(uid);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
    return Scaffold(
      appBar: PartixAppBar(
        title: AppStrings.myTeam,
        showNotifications: false,
        showAvatar: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: const TeamStatsHeader(),
          ),

          // ── View toggle ──
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusButton),
              ),
              child: Row(
                children: [
                  _toggle(context, ref, AppStrings.treeView,
                      team.viewMode == TeamViewMode.tree),
                  _toggle(context, ref, AppStrings.listView,
                      team.viewMode == TeamViewMode.list),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // ── Content ──
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              child: team.viewMode == TeamViewMode.tree
                  ? const TreeViewWidget()
                  : const TeamListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(
      BuildContext ctx, WidgetRef ref, String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(teamProvider).setViewMode(
            label == AppStrings.treeView
                ? TeamViewMode.tree
                : TeamViewMode.list),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: active ? AppColors.brandGradient : null,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusButton),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
