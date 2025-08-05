import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:frontend/features/expense/presentation/widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Today', 'This Week', 'This Month'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
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
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF333335),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
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
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent('Today'),
            _buildTabContent('This Week'),
            _buildTabContent('This Month'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String period) {
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
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String selectedPeriod = 'today';

//   @override
//   void initState() {
//     super.initState();
//     context.read<ExpenseCubit>().loadExpenses(period: selectedPeriod);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI Expense Tracker'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//           ),
//         ],
//       ),
//       body: BlocBuilder<ExpenseCubit, ExpenseState>(
//         builder: (context, state) {
//           if (state is ExpenseLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ExpenseSuccess) {
//             return _buildExpenseList(state.expenses);
//           } else if (state is ExpenseError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, size: 64, color: Colors.red),
//                   SizedBox(height: 16),
//                   Text('Error: ${state.message}'),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context
//                           .read<ExpenseCubit>()
//                           .loadExpenses(period: selectedPeriod);
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Center(child: Text('No expenses found'));
//         },
//       ),
//     );
//   }

// Widget _buildExpenseList(List<Expense> expenses) {
//   if (expenses.isEmpty) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.receipt_long, size: 64, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             'No expenses found',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Add your first expense to get started!',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.grey,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   return ListView.builder(
//     padding: EdgeInsets.all(16),
//     itemCount: expenses.length,
//     itemBuilder: (context, index) {
//       return ExpenseCard(expense: expenses[index]);
//     },
//   );
// }

// void _showFilterDialog() {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Filter Expenses'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           RadioListTile<String>(
//             title: Text('Today'),
//             value: 'today',
//             groupValue: selectedPeriod,
//             onChanged: (value) {
//               setState(() {
//                 selectedPeriod = value!;
//               });
//               Navigator.pop(context);
//               context.read<ExpenseCubit>().loadExpenses(period: selectedPeriod);
//             },
//           ),
//           RadioListTile<String>(
//             title: Text('This Week'),
//             value: 'week',
//             groupValue: selectedPeriod,
//             onChanged: (value) {
//               setState(() {
//                 selectedPeriod = value!;
//               });
//               Navigator.pop(context);
//               context.read<ExpenseCubit>().loadExpenses(period: selectedPeriod);
//             },
//           ),
//           RadioListTile<String>(
//             title: Text('This Month'),
//             value: 'month',
//             groupValue: selectedPeriod,
//             onChanged: (value) {
//               setState(() {
//                 selectedPeriod = value!;
//               });
//               Navigator.pop(context);
//               context.read<ExpenseCubit>().loadExpenses(period: selectedPeriod);
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
