// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/offline_banner.dart
// Orange connectivity banner shown at the top of all screens.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime? lastSyncedAt;
  final VoidCallback? onRetry;

  const OfflineBanner({
    super.key,
    this.lastSyncedAt,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final synced = lastSyncedAt != null
        ? AppStrings.lastUpdated.replaceAll(
            '{time}', DateFormatter.timeAgo(lastSyncedAt!))
        : '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
        border: const Border(
          bottom: BorderSide(color: AppColors.warning, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${AppStrings.offlineBanner} $synced',
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retryNow,
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
