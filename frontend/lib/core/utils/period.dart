class Period {
  final DateTime start;
  final DateTime end; // inclusive end-of-day
  const Period(this.start, this.end);

  // Helpers
  static DateTime _atStartOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  factory Period.today() {
    final now = DateTime.now();
    final start = _atStartOfDay(now);
    final end = _endOfDay(now);
    return Period(start, end);
  }

  factory Period.last7Days() {
    final now = DateTime.now();
    final today = _atStartOfDay(now);
    final start = today.subtract(const Duration(days: 6));
    final end = _endOfDay(today);
    return Period(start, end);
  }

  factory Period.thisWeek() {
    // ISO-like week: Monday..Sunday
    final now = DateTime.now();
    final today = _atStartOfDay(now);
    final monday = today
        .subtract(Duration(days: today.weekday - DateTime.monday)); // Mon = 1
    final sunday = monday.add(const Duration(days: 6));
    return Period(monday, _endOfDay(sunday));
  }

  factory Period.thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end =
        DateTime(now.year, now.month + 1, 0); // last day of month at 00:00
    return Period(start, _endOfDay(end));
  }

  bool contains(DateTime d) => !d.isBefore(start) && !d.isAfter(end);
}
