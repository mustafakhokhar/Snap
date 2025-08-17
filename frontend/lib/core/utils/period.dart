class Period {
  final DateTime start;
  final DateTime end;
  const Period(this.start, this.end);
  factory Period.last7Days() {
    final now = DateTime.now();
    return Period(now.subtract(const Duration(days: 6)), now);
  }
  factory Period.thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return Period(start, end);
  }
  factory Period.thisWeek() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day - now.weekday + 1);
    final end = DateTime(now.year, now.month, now.day + (7 - now.weekday));
    return Period(start, end);
  }
  factory Period.today() {
    final now = DateTime.now();
    return Period(DateTime(now.year, now.month, now.day),
        DateTime(now.year, now.month, now.day));
  }

  bool contains(DateTime d) => !d.isBefore(start) && !d.isAfter(end);
}
