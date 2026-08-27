// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/widgets/tree_view_widget.dart
// SECTION 8 — horizontally + vertically scrollable tree.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/features/team/widgets/tree_node_widget.dart';

class TreeViewWidget extends ConsumerWidget {
  const TreeViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
    final root = team.rootNode;

    if (team.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (root == null) {
      return const Center(child: Text('Team data unavailable'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TreeNodeWidget(node: root, level: 0, isRoot: true),
            if (team.members.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(height: 24, width: 2, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: team.members
                    .map((m) => TreeNodeWidget(node: m, level: 1))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
