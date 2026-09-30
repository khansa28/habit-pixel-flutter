
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'games/games_screen.dart';
import 'achievements_screen.dart';
import 'profile_screen.dart';
import '../theme/theme_controller.dart';
import '../widgets/habit_bottom_nav.dart';
import 'brand_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  // ============================================================
  // CURRENT TAB
  // ============================================================

  int _currentIndex = 0;

  // ============================================================
  // SCREENS
  // ============================================================

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _refreshTheme,
    );

    _screens = const [
      HomeScreen(),
      BrandScreen(),
      GamesScreen(),
      AchievementsScreen(),
      ProfileScreen(),
   
    ];
  }

  // ============================================================
  // THEME REFRESH
  // ============================================================

  void _refreshTheme() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ThemeController.instance.removeListener(
      _refreshTheme,
    );

    super.dispose();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _onItemSelected(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: HabitBottomNav(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
