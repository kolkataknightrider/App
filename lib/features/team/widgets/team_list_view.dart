// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/widgets/team_list_view.dart
// SECTION 8 — filter bar + sort + search + member list.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/providers/team_provider.dart'
    as tp;
import 'team_member_card.dart';

class TeamListView extends ConsumerWidget {
  const TeamListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);

    return Column(
      children: [
        // ── Search ──
        TextField(
          onChanged: team.setSearch,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            prefixIcon:
                const Icon(Icons.search, color: AppColors.textSecondary),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Level filter chips ──
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip(context, ref, 'All Levels', 0),
              _chip(context, ref, 'L1', 1),
              _chip(context, ref, 'L2', 2),
              _chip(context, ref, 'L3', 3),
              _chip(context, ref, 'L4', 4),
              _chip(context, ref, 'L5', 5),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Sort dropdown ──
        Row(
          children: [
            const Text('Sort:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(width: 8),
            DropdownButton<tp.TeamSort>(
              value: team.sort,
              underline: const SizedBox.shrink(),
              dropdownColor: Theme.of(context).cardColor,
              items: const [
                DropdownMenuItem(
                    value: tp.TeamSort.earnings,
                    child: Text('Earnings (High→Low)')),
                DropdownMenuItem(
                    value: tp.TeamSort.joinDate,
                    child: Text('Join Date (Newest)')),
                DropdownMenuItem(
                    value: tp.TeamSort.name, child: Text('Name (A-Z)')),
                DropdownMenuItem(
                    value: tp.TeamSort.teamSize,
                    child: Text('Team Size')),
                DropdownMenuItem(
                    value: tp.TeamSort.rank, child: Text('Rank')),
              ],
              onChanged: (v) => team.setSort(v!),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── List ──
        if (team.loading)
          const Center(child: CircularProgressIndicator())
        else if (team.filteredMembers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
                child: Text('No members match your filters',
                    style: TextStyle(color: AppColors.textSecondary))),
          )
        else
          ...team.filteredMembers
              .map((m) => TeamMemberCard(member: m))
              .toList(),
      ],
    );
  }

  Widget _chip(BuildContext ctx, WidgetRef ref, String label, int level) {
    final active = ref.watch(teamProvider).levelFilter == level;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        selectedColor: AppColors.brandPrimary,
        labelStyle: TextStyle(
          color: active ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
        ),
        onSelected: (_) =>
            ref.read(teamProvider).setLevelFilter(level),
      ),
    );
  }
}
