import 'package:flutter/material.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/widgets/expense_card.dart';

Widget buildExpenseListSheet(
  BuildContext context,
  List<Expense> expenses, 
  Map<String, String> categoryFilterFor,
  
  {
  required String period,
  ScrollController? controller,
  Map<DateTime, GlobalKey>? dayKeys,
}) {
  // Apply category filter
  final sel = categoryFilterFor[period] ?? 'All';
  final data = sel == 'All'
      ? expenses
      : expenses.where((e) => categoryOf(e) == sel).toList();

  // Group by day (newest first)
  final Map<DateTime, List<Expense>> grouped = {};
  for (final e in data) {
    final day = DateTime(e.date.year, e.date.month, e.date.day);
    (grouped[day] ??= []).add(e);
  }
  final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

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
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        controller: controller,
        cacheExtent: 800,
        physics: Theme.of(context).platform == TargetPlatform.iOS
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
                // NEW: pass a key so we can jump to this header
                headerKey:
                    dayKeys == null ? null : (dayKeys[day] = GlobalKey()),
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
  final GlobalKey? headerKey; // NEW

  _SectionHeaderDelegate({
    required this.title,
    required this.background,
    required this.textColor,
    this.height = 36,
    this.headerKey,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final child = Material(
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

    // Wrap with a key container only if provided (so we can jump to it)
    return headerKey == null
        ? child
        : KeyedSubtree(key: headerKey, child: child);
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate old) =>
      old.title != title ||
      old.background != background ||
      old.textColor != textColor ||
      old.height != height ||
      old.headerKey != headerKey;
}



String categoryOf(Expense e) {
  // If your model already has e.category, just return that.
  final t = '${e.title} ${e.description}'.toLowerCase();
  if (t.contains('grocery') || t.contains('market') || t.contains('super'))
    return 'Groceries';
  if (t.contains('restaurant') ||
      t.contains('food') ||
      t.contains('coffee') ||
      t.contains('lunch')) return 'Food & Drink';
  if (t.contains('transport') ||
      t.contains('bus') ||
      t.contains('uber') ||
      t.contains('taxi') ||
      t.contains('fuel')) return 'Transport';
  if (t.contains('bill') ||
      t.contains('utility') ||
      t.contains('electric') ||
      t.contains('internet')) return 'Bills';
  if (t.contains('shopping') || t.contains('clothes') || t.contains('shirt'))
    return 'Shopping';
  return 'Other';
}