// ════════════════════════════════════════════════════════════════
// FILE: lib/core/utils/date_formatter.dart
// Date / time formatting helpers (SECTION 7/10 timestamps).
// ════════════════════════════════════════════════════════════════

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const String _monthLabels = 'JanFebMarAprMayJunJulAugSepOctNovDec';

  /// 15 Jan 2025
  static String medium(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  /// 15 Jan 2025, 3:45 PM
  static String mediumWithTime(DateTime d) =>
      DateFormat('dd MMM yyyy, h:mm a').format(d);

  /// 3:45 PM
  static String time(DateTime d) => DateFormat('h:mm a').format(d);

  /// Today / Yesterday / dd MMM
  static String relativeDay(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(d.year, d.month, d.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return medium(d);
  }

  /// Full relative label e.g. "Today 3:45 PM"
  static String relative(DateTime d) {
    return '${relativeDay(d)} ${time(d)}';
  }

  /// "2 hours ago", "3 days ago" style.
  static String timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 30) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return medium(d);
  }

  /// 2024-01 style month key used by the earning schema.
  static String monthKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  /// 2024-W03 style ISO week key.
  static String weekKey(DateTime d) {
    final week = _isoWeekNumber(d);
    return '${d.year}-W${week.toString().padLeft(2, '0')}';
  }

  static int _isoWeekNumber(DateTime d) {
    final dayOfYear = int.parse(DateFormat('D').format(d));
    return ((dayOfYear - d.weekday + 10) / 7).floor();
  }
}
