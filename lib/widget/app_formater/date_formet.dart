import 'package:intl/intl.dart';

String formatDate(dynamic value) {
  try {
    if (value == null) return "Invalid date";

    DateTime date;

    if (value is DateTime) {
      date = value;
    } 
    else if (value is String) {
      // 1. Try normal ISO parse first
      try {
        date = DateTime.parse(value);
      } catch (e) {
        // 2. If it fails, parse the specific "Mon Mar 16 2026..." format
        // Format string: EEE MMM dd yyyy HH:mm:ss 'GMT'Z
        // Amra shudhu proyojoniyo part-tuku parse korbo
        date = DateFormat("EEE MMM dd yyyy").parse(value.toString());
      }
    } 
    else {
      return "Invalid date";
    }

    // Final formatting: yyyy/MM/dd
    return DateFormat('yyyy/MM/dd').format(date);

  } catch (e) {
    return "Invalid date";
  }
}

