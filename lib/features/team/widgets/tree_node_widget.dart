// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/widgets/tree_node_widget.dart
// SECTION 8 — collapsible tree node (lazy child expansion).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/models/team_member_model.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class TreeNodeWidget extends ConsumerStatefulWidget {
  final TeamMemberModel node;
  final int level;
  final bool isRoot;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.level,
    this.isRoot = false,
  });

  @override
  ConsumerState<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends ConsumerState<TreeNodeWidget> {
  bool _expanded = false;
  List<TeamMemberModel> _children = const [];
  bool _loading = false;

  Future<void> _toggle() async {
    if (widget.node.children.isEmpty) return;
    if (_expanded) {
      setState(() => _expanded = false);
      return;
    }
    setState(() {
      _expanded = true;
      _loading = true;
    });
    try {
      final list = await ref
          .read(teamProvider)
          .fetchChildren(widget.node.userId, widget.level + 1);
      _children = list;
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = AppColors.rankColor(widget.node.rank);
    final hasChildren = widget.node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _toggle,
          onLongPress: () {
            HapticFeedback.mediumImpact();
            context.push(AppRoutes.memberDetailPath(widget.node.userId));
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isRoot
                  ? rankColor.withOpacity(0.2)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: rankColor,
                width: widget.isRoot ? 2 : 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.isRoot ? 'YOU' : widget.node.fullName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: rankColor,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.node.memberId,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 10)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    StatusBadge.rank(widget.node.rank),
                    const SizedBox(width: 6),
                    if (widget.node.isActive)
                      const Icon(Icons.circle,
                          size: 8, color: AppColors.success)
                    else
                      const Icon(Icons.circle,
                          size: 8, color: AppColors.textTertiary),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8),
            child: _loading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _children
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TreeNodeWidget(
                                  node: c, level: widget.level + 1),
                            ))
                        .toList(),
                  ),
          ),
      ],
    );
  }
}
