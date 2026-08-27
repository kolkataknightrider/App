// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/empty_state_widget.dart
// Empty state with an icon / optional Lottie placeholder.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_strings.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? custom;

  const EmptyStateWidget({
    super.key,
    this.message = AppStrings.noData,
    this.icon = Icons.inbox_rounded,
    this.custom,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (custom != null)
              custom!
            else
              Icon(icon, size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
