import 'package:flutter/material.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/widgets/expense_card.dart';

Widget buildExpenseListSheet(BuildContext context, List<Expense> expenses) {
  // Group by calendar day and sort desc (newest first)
  final Map<DateTime, List<Expense>> grouped = {};
  for (final e in expenses) {
    final day = DateTime(e.date.year, e.date.month, e.date.day);
    (grouped[day] ??= []).add(e);
  }
  final days = grouped.keys.toList()
    ..sort((a, b) => b.compareTo(a)); // newest first

  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: CustomScrollView(
        cacheExtent: 800,
        physics: isIOS
            ? const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics())
            : const ClampingScrollPhysics(),
        slivers: [
          // grab handle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          // sections
          for (final day in days) ...[
            SliverPersistentHeader(
              pinned: true,
              delegate: _SectionHeaderDelegate(
                title: _formatDate(day),
                background: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.titleSmall?.color ??
                    Colors.white,
                height: 32,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    buildExpenseCard(context, grouped[day]![index]),
                childCount: grouped[day]!.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                addSemanticIndexes: false,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],

          // bottom safe gap
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    ),
  );
}

String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expenseDate = DateTime(date.year, date.month, date.day);
  final formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';

  if (expenseDate == today) {
    return 'Today - $formattedDate';
  } else if (expenseDate == today.subtract(const Duration(days: 1))) {
    return 'Yesterday - $formattedDate';
  } else {
    return formattedDate;
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color background;
  final Color textColor;
  final double height;

  _SectionHeaderDelegate({
    required this.title,
    required this.background,
    required this.textColor,
    this.height = 36,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: background,
      elevation: overlapsContent ? 1 : 0,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.9),
              ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate old) =>
      old.title != title ||
      old.background != background ||
      old.textColor != textColor ||
      old.height != height;
}
