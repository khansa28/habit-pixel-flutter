import 'package:flutter/material.dart';

import '../services/habit_store.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import '../widgets/habit_bottom_nav.dart';

import 'achievements_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'brand_screen.dart';
import 'games/games_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ============================================================
  // NAVIGATION
  // ============================================================

  int currentIndex = 0;

  // ============================================================
  // SCREENS
  // ============================================================

  final List<Widget> screens = const [
    HomeScreen(),
    BrandScreen(),
    GamesScreen(),
    AchievementsScreen(),
    ProfileScreen(),
  ];

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('FIRST_FRAME_REACHED: ${DateTime.now()}');
    });

    ThemeController.instance.addListener(_refreshTheme);

    // ----------------------------------------------------------
    // IMPORTANT:
    //
    // MainScreen is rendered immediately.
    //
    // Application initialization starts only AFTER the first
    // Flutter frame has been displayed.
    //
    // This means the user sees the real Home screen instead of
    // another Flutter splash/loading screen.
    // ----------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppInBackground();
    });
  }

  // ============================================================
  // BACKGROUND INITIALIZATION
  // ============================================================

  // Future<void> _initializeAppInBackground() async {
  //   try {
  //     // --------------------------------------------------------
  //     // DATABASE + APPLICATION DATA
  //     // --------------------------------------------------------
  //     //
  //     // HomeScreen is already visible while this happens.
  //     //
  //     // HabitStore will notify its listeners after the data has
  //     // been loaded, causing HomeScreen to refresh automatically.
  //     // --------------------------------------------------------

  //     await HabitStore.instance.init();

  //     // --------------------------------------------------------
  //     // THEME
  //     // --------------------------------------------------------
  //     //
  //     // Theme initialization happens after the application
  //     // surface is already visible.
  //     // --------------------------------------------------------

  //     await ThemeController.instance.init();

  //     // --------------------------------------------------------
  //     // NOTIFICATIONS
  //     // --------------------------------------------------------
  //     //
  //     // Notification initialization must not control whether
  //     // the Home screen is displayed.
  //     // --------------------------------------------------------

  //     NotificationService.initialize();
  //   } catch (error, stackTrace) {
  //     // --------------------------------------------------------
  //     // IMPORTANT:
  //     //
  //     // Initialization failure must NOT replace the Home screen
  //     // with an error page.
  //     //
  //     // The app has already been rendered, so we simply log the
  //     // problem. Individual screens/services can handle their
  //     // own unavailable-data state.
  //     // --------------------------------------------------------

  //     debugPrint(
  //       'Background application initialization error: $error',
  //     );

  //     debugPrint(
  //       '$stackTrace',
  //     );
  //   }
  // }

  Future<void> _initializeAppInBackground() async {
    final stopwatch = Stopwatch()..start();

    try {
      debugPrint('STARTUP_TRACE: initialization START');

      debugPrint('STARTUP_TRACE: HabitStore.init START');

      await HabitStore.instance.init();

      debugPrint(
        'STARTUP_TRACE: HabitStore.init END '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      debugPrint('STARTUP_TRACE: ThemeController.init START');

      await ThemeController.instance.init();

      debugPrint(
        'STARTUP_TRACE: ThemeController.init END '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      debugPrint('STARTUP_TRACE: NotificationService.initialize START');

      await NotificationService.initialize();

      debugPrint(
        'STARTUP_TRACE: NotificationService.initialize END '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      debugPrint(
        'STARTUP_TRACE: initialization COMPLETE '
        '${stopwatch.elapsedMilliseconds} ms',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'STARTUP_TRACE: initialization ERROR '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      debugPrint('Background application initialization error: $error');

      debugPrint('$stackTrace');
    }
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
  // NAVIGATION
  // ============================================================

  void onNavigationChanged(int index) {
    if (index == currentIndex) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ThemeController.instance.removeListener(_refreshTheme);

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    final backgroundColor = isDark
        ? AppColors.darkBackgroundTop
        : AppColors.backgroundTop;

    // ----------------------------------------------------------
    // IMPORTANT:
    //
    // There is NO splash state here.
    // There is NO loading state here.
    // There is NO initialization gate here.
    //
    // The real application is rendered immediately.
    // ----------------------------------------------------------

    return Scaffold(
      backgroundColor: backgroundColor,

      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: SafeArea(
        top: false,
        child: HabitBottomNav(
          currentIndex: currentIndex,
          onItemSelected: onNavigationChanged,
        ),
      ),
    );
  }
}
