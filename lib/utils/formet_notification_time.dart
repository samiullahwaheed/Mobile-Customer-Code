String formatNotificationTime(dynamic input) {
  if (input == null) return 'Invalid time';

  DateTime? dateTime;

  // Input type check
  if (input is DateTime) {
    dateTime = input;
  } else if (input is String && input.isNotEmpty) {
    try {
      dateTime = DateTime.parse(input);
    } catch (e) {
      return 'Invalid time';
    }
  } else {
    return 'Invalid time';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks}w ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '${months}m ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '${years}y ago';
  }
}
