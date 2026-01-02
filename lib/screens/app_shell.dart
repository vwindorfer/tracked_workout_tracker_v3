import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    HistoryScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.getPrimary(context);
    final surfaceColor = AppTheme.getSurface(context);
    final borderColor = AppTheme.getBorder(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: borderColor,
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: surfaceColor,
          indicatorColor: primaryColor.withValues(alpha: 0.2),
          surfaceTintColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: primaryColor),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history, color: primaryColor),
              label: 'History',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart, color: primaryColor),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: primaryColor),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
