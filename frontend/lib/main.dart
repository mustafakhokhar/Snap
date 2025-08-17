import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/di/injection.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/expense/presentation/cubits/add_expense_cubit.dart';
import 'package:frontend/features/expense/presentation/cubits/expenses_list_cubit.dart';
import 'package:frontend/features/expense/presentation/pages/add_expense_page.dart';
import 'package:frontend/features/expense/presentation/pages/home_screen.dart';
import 'package:frontend/features/expense/presentation/pages/pending_screen.dart';
import 'package:frontend/features/expense/presentation/pages/stats_screen.dart';
import 'package:frontend/features/expense/presentation/pages/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Expense Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<ExpensesListCubit>()),
          BlocProvider(create: (context) => getIt<AddExpenseCubit>()),
        ],
        child: MainApp(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    PendingScreen(),
    AddExpensePage(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // _currentIndex = 2;
          // setState(() {});
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        clipBehavior: Clip.antiAlias,
        notchMargin: 10,
        padding: const EdgeInsets.all(0),
        elevation: 0,
        height: height * 0.07,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          enableFeedback: false,
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pending),
              label: 'Pending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
