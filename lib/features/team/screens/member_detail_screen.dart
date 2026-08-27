// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/screens/member_detail_screen.dart
// SECTION 8 — full member detail page.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/models/team_member_model.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../widgets/team_member_card.dart';

class MemberDetailScreen extends ConsumerStatefulWidget {
  final String memberId;
  const MemberDetailScreen({super.key, required this.memberId});

  @override
  ConsumerState<MemberDetailScreen> createState() =>
      _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen> {
  TeamMemberModel? _node;
  List<TeamMemberModel> _theirMembers = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final node =
          await FirestoreService.instance.getTeamNode(widget.memberId);
      List<TeamMemberModel> their = const [];
      if (node != null && node.children.isNotEmpty) {
        their = await FirestoreService.instance.getTeamNodes(node.children);
      }
      setState(() {
        _node = node;
        _theirMembers = their;
      });
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = _node;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : node == null
              ? const Center(child: Text('Member not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero ──
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 44,
                              backgroundColor: AppColors
                                  .rankColor(node.rank)
                                  .withOpacity(0.2),
                              backgroundImage: node.profilePhotoUrl != null
                                  ? NetworkImage(node.profilePhotoUrl!)
                                  : null,
                              child: node.profilePhotoUrl == null
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Text(node.fullName,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            Text(node.memberId,
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            StatusBadge.rank(node.rank),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  node.isActive
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  size: 10,
                                  color: node.isActive
                                      ? AppColors.success
                                      : AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  node.isActive
                                      ? AppStrings.active
                                      : AppStrings.inactive,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      // ── Stats grid ──
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _stat('Position', 'Level ${node.level}'),
                          _stat('Direct Referrals',
                              '${node.directReferrals}'),
                          _stat('Total Team', '${node.totalDownline}'),
                          _stat('Monthly Earnings',
                              '₹${node.monthlyEarnings.toInt()}'),
                          if (node.joiningDate != null)
                            _stat('Joined',
                                DateFormatter.medium(node.joiningDate!)),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      const Text('Their Direct Members',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      if (_theirMembers.isEmpty)
                        const Text('No direct members yet.',
                            style: TextStyle(color: AppColors.textSecondary))
                      else
                        ..._theirMembers
                            .map((m) => TeamMemberCard(member: m))
                            .toList(),
                      const SizedBox(height: AppDimensions.xl),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
