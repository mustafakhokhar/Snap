import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/cubits/expenses_list_cubit.dart';
import 'package:frontend/features/expense/presentation/widgets/expense_list.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Today', 'This Week', 'This Month'];
  String _selectedPeriod = 'today';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // Load expenses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpensesListCubit>().load(Period.today());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedPeriod = 'today';
          context.read<ExpensesListCubit>().load(Period.today());
          break;
        case 1:
          _selectedPeriod = 'week';
          context.read<ExpensesListCubit>().load(Period.thisWeek());
          break;
        case 2:
          _selectedPeriod = 'month';
          context.read<ExpensesListCubit>().load(Period.thisMonth());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // Greeting and name
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning,',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'Mustafa Khokhar',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.07),
            child: Container(
              height: height * 0.05,
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF333335),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                indicatorWeight: 0,
                dividerColor: Colors.transparent,
                controller: _tabController,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(0xFF333335),
                unselectedLabelColor: Colors.grey[300],
                indicator: BoxDecoration(
                  color: const Color(0xFFD1F755),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                unselectedLabelStyle:
                    Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                        ),
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                onTap: _onTabChanged,
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent(_selectedPeriod),
            _buildTabContent(_selectedPeriod),
            _buildTabContent(_selectedPeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String period) {
    return BlocBuilder<ExpensesListCubit, ExpensesListState>(
      builder: (context, state) {
        if (state is ExpensesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpensesLoaded) {
          final expenses = state.items;
          if (expenses.isEmpty) return _buildExpenseEmptyState(period);

          if (period == 'today') return _buildExpenseTodayContent(expenses);
          if (period == 'week') return _buildExpenseWeekContent(expenses);
          if (period == 'month') return _buildExpenseMonthContent(expenses);

          return _buildExpenseEmptyState(period);
        } else if (state is ExpensesError) {
          return _buildExpenseErrorState(state.message);
        }
        return _buildExpenseEmptyState(period);
      },
    );
  }

  Widget _buildExpenseTodayContent(List<Expense> expenses) {
    final totalAmount =
        expenses.fold<double>(0, (sum, expense) => sum + expense.amount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Expense Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            width: double.infinity,
            child: Card(
              elevation: 4,
              color: const Color(0xFF333335),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0
                        ]),
                        child: Lottie.asset(
                          'assets/animations/lines.json',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Expense',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[400],
                                    letterSpacing: 1.2,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Rs ${totalAmount.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Expense List
          Expanded(
            child: buildExpenseListSheet(context, expenses),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseWeekContent(List<Expense> all) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final delta = (date.weekday - DateTime.monday);
    final weekStart = date.subtract(Duration(days: delta));
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Filter this week’s expenses
    final week = all
        .where((e) =>
            e.expenseDate
                .isAfter(weekStart.subtract(const Duration(milliseconds: 1))) &&
            e.expenseDate.isBefore(weekEnd))
        .toList();

    // Totals per weekday (Mon..Sun)
    final totals = List<double>.filled(7, 0);
    for (final e in week) {
      final idx = ((e.expenseDate.weekday + 6) % 7); // Mon=0 ... Sun=6
      totals[idx] += e.amount;
    }

    final totalThisWeek = totals.fold<double>(0, (a, b) => a + b);

    return Column(
      children: [
        // Header summary + compact bars
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'This Week',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'Rs ${totalThisWeek.toStringAsFixed(0)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _WeekBars(totals: totals), // super light widget below
        ),
        const SizedBox(height: 8),
        // The same fast sticky list you use elsewhere
        Expanded(child: buildExpenseListSheet(context, week)),
      ],
    );
  }

  Widget _buildExpenseMonthContent(List<Expense> all) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    final lastDay = nextMonth.subtract(const Duration(days: 1));

    final month = all
        .where((e) =>
            !e.expenseDate.isBefore(firstDay) &&
            !e.expenseDate.isAfter(lastDay))
        .toList();

    // Totals per calendar day
    final daysInMonth = lastDay.day;
    final dayTotals = List<double>.filled(daysInMonth, 0);
    for (final e in month) {
      dayTotals[e.expenseDate.day - 1] += e.amount;
    }
    final monthTotal = dayTotals.fold<double>(0, (a, b) => a + b);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'This Month',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'Rs ${monthTotal.toStringAsFixed(0)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        // Heatmap grid (7 columns) — cheap to draw
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _MonthHeatmap(
            firstDay: firstDay,
            lastDay: lastDay,
            totals: dayTotals,
          ),
        ),
        const SizedBox(height: 8),

        Expanded(child: buildExpenseListSheet(context, month)),
      ],
    );
  }

  Widget _buildExpenseEmptyState(String period) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses for $period',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses for $period',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first expense to get started!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading expenses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ExpensesListCubit>().refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  final List<double> totals; // length 7, Mon..Sun
  const _WeekBars({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxVal = totals.fold<double>(0, (m, v) => math.max(m, v));
    final base = 6.0; // minimum visible height
    final maxBar = 84.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        final t = totals[i];
        final h = maxVal == 0 ? base : base + (t / maxVal) * (maxBar - base);
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: h,
                decoration: BoxDecoration(
                  color: cs.secondaryContainer.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 6),
              Text(labels[i],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.7),
                      )),
            ],
          ),
        );
      }),
    );
  }
}

class _MonthHeatmap extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final List<double> totals; // index = day-1
  const _MonthHeatmap({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    final totalMax = totals.fold<double>(0, (m, v) => math.max(m, v));
    final cs = Theme.of(context).colorScheme;

    // Layout constants
    const cell = 16.0;
    const gap = 4.0;
    final startOffset = (firstDay.weekday + 6) % 7; // Mon=0..Sun=6
    final cells = startOffset + lastDay.day;
    final rows = ((cells + 6) ~/ 7); // ceil
    final height = rows * cell + (rows - 1) * gap;

    return RepaintBoundary(
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _MonthHeatmapPainter(
            firstDay: firstDay,
            totals: totals,
            startOffset: startOffset,
            cell: cell,
            gap: gap,
            rows: rows,
            surface: cs.surfaceVariant,
            high: cs.primary, // use theme primary as high-intensity color
            maxVal: totalMax == 0 ? 1 : totalMax,
          ),
        ),
      ),
    );
  }
}

class _MonthHeatmapPainter extends CustomPainter {
  final DateTime firstDay;
  final List<double> totals;
  final int startOffset, rows;
  final double cell, gap, maxVal;
  final Color surface, high;

  _MonthHeatmapPainter({
    required this.firstDay,
    required this.totals,
    required this.startOffset,
    required this.rows,
    required this.cell,
    required this.gap,
    required this.surface,
    required this.high,
    required this.maxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final days = totals.length;

    for (int d = 0; d < days; d++) {
      final idx = startOffset + d;
      final row = idx ~/ 7;
      final col = idx % 7;
      final x = col * (cell + gap);
      final y = row * (cell + gap);

      final t = totals[d] / maxVal; // 0..1
      final color = Color.lerp(surface, high, t.clamp(0, 1))!;
      paint.color = color.withOpacity(0.85);
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell, cell),
        const Radius.circular(4),
      );
      canvas.drawRRect(r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MonthHeatmapPainter old) {
    return old.totals != totals ||
        old.startOffset != startOffset ||
        old.cell != cell ||
        old.gap != gap ||
        old.maxVal != maxVal ||
        old.surface != surface ||
        old.high != high;
  }
}
