extension DateTimeUtils on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get toDateOnly => DateTime(year, month, day);
}
