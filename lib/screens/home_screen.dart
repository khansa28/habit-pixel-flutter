
import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/habit_store.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/empty_habits_state.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_floating_button.dart';
import '../widgets/streak_card.dart';
import '../widgets/xp_card.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver {
  final HabitStore habitStore = HabitStore.instance;
  final ThemeController themeController =
      ThemeController.instance;

  List<Habit> get habits => habitStore.habits;

  bool get _isDark => themeController.isDarkMode;

  Color get _backgroundTop => _isDark
      ? AppColors.darkBackgroundTop
      : AppColors.backgroundTop;

  Color get _backgroundMiddle => _isDark
      ? AppColors.darkBackgroundMiddle
      : AppColors.backgroundMiddle;

  Color get _backgroundBottom => _isDark
      ? AppColors.darkBackgroundBottom
      : AppColors.backgroundBottom;

  Color get _card => _isDark
      ? AppColors.darkCardBackground
      : AppColors.cardBackground;

  Color get _primary => _isDark
      ? AppColors.darkPrimaryBlue
      : AppColors.primaryBlue;

  Color get _textPrimary => _isDark
      ? AppColors.darkPrimaryText
      : AppColors.primaryText;

  Color get _textSecondary => _isDark
      ? AppColors.darkSecondaryText
      : AppColors.secondaryText;

  Color get _border => _isDark
      ? AppColors.darkCardBorder
      : AppColors.cardBorder;

  Color get _blueGlow => _isDark
      ? AppColors.darkBlueGlow
      : AppColors.blueGlow;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);


    habitStore.addListener(_refreshHome);

    themeController.addListener(_refreshHome);

    NotificationService.addListener(
      _handleNotificationNavigation,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNotificationNavigation();
    });
  }

  void _refreshHome() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      habitStore.resetForNewDay();

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    NotificationService.removeListener(
      _handleNotificationNavigation,
    );

    habitStore.removeListener(_refreshHome);
    themeController.removeListener(_refreshHome);

    super.dispose();
  }

  void _handleNotificationNavigation() {
    final habitId =
        NotificationService.consumePendingHabitId();

    if (habitId == null) {
      return;
    }

    Habit? matchingHabit;

    for (final habit in habits) {
      if (habit.id == habitId) {
        matchingHabit = habit;
        break;
      }
    }

    if (matchingHabit == null) {
      return;
    }

    openHabitDetail(matchingHabit);
  }

  int get completedHabits {
    return habits.where((habit) => habit.completed).length;
  }

  int get currentStreak {
    if (habits.isEmpty) {
      return 0;
    }

    int highestStreak = 0;

    for (final habit in habits) {
      if (habit.streak > highestStreak) {
        highestStreak = habit.streak;
      }
    }

    return highestStreak;
  }

  Future<void> openHabitDetail(Habit habit) async {
    final updatedHabit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(
          habit: habit,
        ),
      ),
    );

    if (updatedHabit != null) {
      habitStore.update(updatedHabit);

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> addNewHabit() async {
    final newHabit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddHabitScreen(),
      ),
    );

    if (newHabit != null) {
      habitStore.add(newHabit);

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = habits.isEmpty
        ? 0.0
        : completedHabits / habits.length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _backgroundTop,
            _backgroundMiddle,
            _backgroundBottom,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 20,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Habit',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'Pixel',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _card,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _primary.withValues(
                      alpha: 0.25,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(
                        alpha: _isDark ? 0.20 : 0.14,
                      ),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: _primary,
                  size: 23,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: -100,
              right: -130,
              child: _glow(
                size: 330,
                color: _blueGlow,
                opacity: _isDark ? 0.18 : 0.13,
              ),
            ),
            Positioned(
              top: 350,
              left: -150,
              child: _glow(
                size: 350,
                color: _isDark
                    ? AppColors.darkPrimaryBlue
                    : const Color(0xFF2D8CFF),
                opacity: _isDark ? 0.12 : 0.09,
              ),
            ),
            Positioned(
              bottom: -180,
              right: -130,
              child: _glow(
                size: 380,
                color: _primary,
                opacity: _isDark ? 0.11 : 0.07,
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                110,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good evening 👋',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      color: _textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Let's build a better day.",
                    style: TextStyle(
                      fontSize: 15,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  XpCard(
                    habitStore: habitStore,
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: StreakCard(
                          currentStreak: currentStreak,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DailyProgressCard(
                          progress: progress,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 31),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Habits",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: addNewHabit,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: _primary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withValues(
                                  alpha:
                                      _isDark ? 0.16 : 0.10,
                                ),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: _primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: _primary,
                                  fontWeight:
                                      FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (habits.isEmpty)
                    EmptyHabitsState(
                      onCreateHabit: addNewHabit,
                    ),
                  ...habits.map(
                    (habit) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 13,
                      ),
                      child: HabitCard(
                        habit: habit,
                        onTap: () =>
                            openHabitDetail(habit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: HomeFloatingButton(
          onPressed: addNewHabit,
        ),
      ),
    );
  }

  Widget _glow({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

