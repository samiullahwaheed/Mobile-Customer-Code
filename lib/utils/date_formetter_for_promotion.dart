String dateFormetterForPromotion(dynamic inputDate) {
  if (inputDate == null) return "invalid";

  DateTime? date;

  // Check type
  if (inputDate is DateTime) {
    date = inputDate;
  } else if (inputDate is String) {
    if (inputDate.trim().isEmpty) return "invalid";
    try {
      date = DateTime.parse(inputDate);
    } catch (e) {
      return "invalid";
    }
  } else if (inputDate is int) {
    date = DateTime.fromMillisecondsSinceEpoch(inputDate);
  } else {
    return "invalid";
  }

  // Month short name
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String month = months[date.month - 1];
  String day = date.day.toString();
  String year = date.year.toString();

  return "$month $day, $year";
}
