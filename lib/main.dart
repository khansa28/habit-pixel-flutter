import 'package:flutter/material.dart';

import 'services/brand_sync_scheduler.dart';
// import 'package:habit_gamification_new/models/brand.dart';
// import 'services/connectivity_service.dart';

import 'screens/main_screen.dart';
import 'theme/theme_controller.dart';

// import 'services/brand_database_service.dart';

final syncScheduler = BrandSyncScheduler();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  syncScheduler.start();
  // await BrandDatabaseService().database;

  runApp(const HabitApp());
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HabitPixel',

          themeMode: ThemeController.instance.themeMode,

          // ====================================================
          // LIGHT THEME
          // ====================================================
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.light,

            scaffoldBackgroundColor: Colors.transparent,

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF55C99A),
              brightness: Brightness.light,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),

            cardTheme: const CardThemeData(elevation: 0),
          ),

          // ====================================================
          // DARK THEME
          // ====================================================
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.dark,

            scaffoldBackgroundColor: const Color(0xFF081522),

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF55C99A),
              brightness: Brightness.dark,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),

            cardTheme: const CardThemeData(elevation: 0),
          ),

          // ====================================================
          // REAL APPLICATION
          // ====================================================
          home: const MainScreen(),
        );
      },
    );
  }
}
