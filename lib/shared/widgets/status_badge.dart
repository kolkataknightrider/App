// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/status_badge.dart
// Colored status / rank badge (fully rounded chip).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool filled;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.filled = true,
  });

  factory StatusBadge.rank(String rankName) {
    final c = AppColors.rankColor(rankName);
    return StatusBadge(label: rankName, color: c);
  }

  factory StatusBadge.status(String status) {
    final map = <String, Color>{
      'pending': AppColors.warning,
      'processing': AppColors.info,
      'completed': AppColors.success,
      'rejected': AppColors.error,
      'active': AppColors.success,
      'inactive': AppColors.textTertiary,
      'verified': AppColors.success,
    };
    return StatusBadge(
      label: status.toUpperCase(),
      color: map[status.toLowerCase()] ?? AppColors.textSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.15) : Colors.transparent,
        border: filled ? null : Border.all(color: color),
        borderRadius:
            BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
