import 'package:flutter/material.dart';

import '../services/habit_store.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // ANIMATION CONTROLLERS
  // ============================================================

  late AnimationController mainController;
  late AnimationController glowController;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> glowAnimation;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _refreshTheme,
    );

    // ==========================================================
    // MAIN ANIMATION
    // ==========================================================

    mainController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    );

    fadeAnimation = CurvedAnimation(
      parent: mainController,
      curve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(
      begin: 0.80,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: mainController,
        curve: Curves.easeOutBack,
      ),
    );

    // ==========================================================
    // GLOW ANIMATION
    // ==========================================================

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.12,
      end: 0.28,
    ).animate(
      CurvedAnimation(
        parent: glowController,
        curve: Curves.easeInOut,
      ),
    );

    // ==========================================================
    // START MAIN ANIMATION
    // ==========================================================

    mainController.forward();

    // ==========================================================
    // START INITIALIZATION AFTER FIRST FRAME
    // ==========================================================
    //
    // IMPORTANT:
    // We intentionally wait until Flutter has rendered
    // the splash screen once before opening Hive.
    //
    // This prevents the slow Hive.openBox() operation from
    // delaying the first visible screen.
    // ==========================================================

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _initializeApp();
      },
    );
  }

  // ============================================================
  // INITIALIZE APP
  // ============================================================

  Future<void> _initializeApp() async {
    final stopwatch =
        Stopwatch()..start();

    print('🚀 APP START');
    print('1️⃣ Starting HabitStore...');

    try {
      // ========================================================
      // HABIT STORE
      // ========================================================

      await HabitStore.instance.init();

      print(
        '✅ HabitStore finished: '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      // ========================================================
      // THEME
      // ========================================================

      print(
        '2️⃣ Starting ThemeController...',
      );

      await ThemeController.instance.init();

      print(
        '✅ ThemeController finished: '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      // ========================================================
      // NOTIFICATIONS
      // ========================================================
      //
      // Notifications are NOT awaited here.
      //
      // They initialize in the background so they cannot
      // delay navigation to the HomeScreen.
      // ========================================================

      print(
        '3️⃣ Starting notifications...',
      );

      NotificationService.initialize().then(
        (_) {
          print(
            '✅ Notifications initialized',
          );
        },
      ).catchError(
        (error) {
          print(
            '❌ Notification error: $error',
          );
        },
      );

      // ========================================================
      // MINIMUM SPLASH TIME
      // ========================================================
      //
      // If initialization finishes very quickly, keep the
      // splash visible for at least 2 seconds.
      // If initialization takes longer, we don't add another
      // 2 seconds unnecessarily.
      // ========================================================

      final elapsed =
          stopwatch.elapsedMilliseconds;

      const minimumSplashTime =
          2000;

      if (elapsed <
          minimumSplashTime) {
        await Future<void>.delayed(
          Duration(
            milliseconds:
                minimumSplashTime -
                    elapsed,
          ),
        );
      }

      // ========================================================
      // NAVIGATE TO HOME
      // ========================================================

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MainScreen(),
        ),
      );
    } catch (error) {
      // ========================================================
      // INITIALIZATION ERROR
      // ========================================================

      print(
        '❌ App initialization error: $error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed to initialize app: $error',
          ),
        ),
      );
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
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ThemeController.instance.removeListener(
      _refreshTheme,
    );

    mainController.dispose();
    glowController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        ThemeController.instance.isDarkMode;

    final backgroundTop = isDark
        ? AppColors.darkBackgroundTop
        : AppColors.backgroundTop;

    final backgroundMiddle = isDark
        ? AppColors.darkBackgroundMiddle
        : AppColors.backgroundMiddle;

    final backgroundBottom = isDark
        ? AppColors.darkBackgroundBottom
        : AppColors.backgroundBottom;

    final primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

    final brightBlue = isDark
        ? AppColors.darkBrightBlue
        : AppColors.brightBlue;

    final gradientBlueLight = isDark
        ? AppColors.darkGradientBlueLight
        : AppColors.gradientBlueLight;

    final gradientBlueDark = isDark
        ? AppColors.darkGradientBlueDark
        : AppColors.gradientBlueDark;

    final primaryText = isDark
        ? AppColors.darkPrimaryText
        : AppColors.primaryText;

    final secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.secondaryText;

    final mutedText = isDark
        ? AppColors.darkMutedText
        : AppColors.mutedText;

    final progressBackground = isDark
        ? AppColors.darkProgressBackground
        : AppColors.progressBackground;

    return Scaffold(
      backgroundColor: backgroundTop,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundTop,
              backgroundMiddle,
              backgroundBottom,
            ],
          ),
        ),

        child: Stack(
          children: [
            // ==================================================
            // TOP RIGHT BLUE GLOW
            // ==================================================

            Positioned(
              top: -100,
              right: -90,
              child: AnimatedBuilder(
                animation: glowAnimation,
                builder: (
                  context,
                  child,
                ) {
                  return Container(
                    width: 290,
                    height: 290,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withValues(
                        alpha:
                            glowAnimation.value,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              brightBlue.withValues(
                            alpha:
                                glowAnimation.value,
                          ),
                          blurRadius: 100,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // BOTTOM LEFT BLUE GLOW
            // ==================================================

            Positioned(
              bottom: -130,
              left: -110,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brightBlue.withValues(
                    alpha:
                        isDark ? 0.14 : 0.13,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          primaryBlue.withValues(
                        alpha:
                            isDark ? 0.14 : 0.10,
                      ),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // SMALL DECORATIVE GLOW
            // ==================================================

            Positioned(
              top: 170,
              left: -60,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brightBlue.withValues(
                    alpha:
                        isDark ? 0.09 : 0.07,
                  ),
                ),
              ),
            ),

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      // ========================================
                      // LOGO
                      // ========================================

                      Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment.topLeft,
                            end:
                                Alignment.bottomRight,
                            colors: [
                              gradientBlueLight,
                              gradientBlueDark,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            34,
                          ),
                          border:
                              Border.all(
                            color:
                                Colors.white.withValues(
                              alpha:
                                  isDark
                                      ? 0.25
                                      : 0.75,
                            ),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  primaryBlue.withValues(
                                alpha:
                                    isDark
                                        ? 0.35
                                        : 0.25,
                              ),
                              blurRadius: 35,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color:
                                  brightBlue.withValues(
                                alpha:
                                    isDark
                                        ? 0.20
                                        : 0.15,
                              ),
                              blurRadius: 60,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons
                                .auto_awesome_rounded,
                            size: 58,
                            color:
                                Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // ========================================
                      // APP NAME
                      // ========================================

                      Text(
                        'HabitPixel',
                        style: TextStyle(
                          color:
                              primaryText,
                          fontSize: 36,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // ========================================
                      // TAGLINE
                      // ========================================

                      Text(
                        'Build habits. Earn progress.',
                        style: TextStyle(
                          color:
                              secondaryText,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(
                        height: 38,
                      ),

                      // ========================================
                      // LOADING BAR
                      // ========================================

                      Container(
                        width: 90,
                        height: 5,
                        decoration:
                            BoxDecoration(
                          color:
                              progressBackground,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          child:
                              LinearProgressIndicator(
                            minHeight: 5,
                            backgroundColor:
                                Colors.transparent,
                            color:
                                primaryBlue,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // ========================================
                      // BOTTOM MESSAGE
                      // ========================================

                      Text(
                        'Your journey starts here',
                        style: TextStyle(
                          color:
                              mutedText,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}