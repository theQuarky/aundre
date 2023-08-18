import 'package:intl/intl.dart';

String format(DateTime timestamp) {
  final datetime = DateTime.fromMillisecondsSinceEpoch(
    timestamp.millisecondsSinceEpoch,
  );
  final now = DateTime.now();
  final difference = now.difference(datetime);

  final isJustNow = difference.inMilliseconds / 1000 < 60;

  if (isJustNow) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return Intl.plural(
      difference.inMinutes,
      one: '1 minute ago',
      other: '${difference.inMinutes} minutes ago',
    );
  } else if (difference.inHours < 24) {
    return Intl.plural(
      difference.inHours,
      one: '1 hour ago',
      other: '${difference.inHours} hours ago',
    );
  } else if (difference.inDays < 7) {
    return Intl.plural(
      difference.inDays,
      one: '1 day ago',
      other: '${difference.inDays} days ago',
    );
  } else {
    return DateFormat('MM/dd/yyyy').format(datetime); // Fallback to date
  }
}
