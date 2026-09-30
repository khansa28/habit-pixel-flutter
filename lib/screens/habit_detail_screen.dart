
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/habit.dart';
import '../services/habit_timer_service.dart';
import '../services/habit_store.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({
    super.key,
    required this.habit,
  });

  @override
  State<HabitDetailScreen> createState() =>
      _HabitDetailScreenState();
}

class _HabitDetailScreenState
    extends State<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
  final HabitTimerService timerService =
      HabitTimerService.instance;

  final HabitStore habitStore =
      HabitStore.instance;

  // ============================================================
  // XP REWARD DISPLAY
  // ============================================================

  int xpEarned = 0;

  late AnimationController completionAnimationController;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _refreshTheme,
    );

    completionAnimationController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 700,
      ),
    );

    timerService.addListener(_timerUpdated);

    // Make sure completed state is correct.
    if (widget.habit.progress >= widget.habit.goal) {
      widget.habit.completed = true;
    } else {
      widget.habit.completed = false;
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

    timerService.removeListener(_timerUpdated);
    completionAnimationController.dispose();

    super.dispose();
  }

  // ============================================================
  // THEME COLORS
  // ============================================================

  bool get isDark =>
      ThemeController.instance.isDarkMode;

  Color get backgroundTop =>
      isDark
          ? AppColors.darkBackgroundTop
          : AppColors.backgroundTop;

  Color get backgroundMiddle =>
      isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  Color get backgroundBottom =>
      isDark
          ? AppColors.darkBackgroundBottom
          : AppColors.backgroundBottom;

  Color get primaryBlue =>
      isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get brightBlue =>
      isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get primaryText =>
      isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get secondaryText =>
      isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get cardBackground =>
      isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get cardBorder =>
      isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get successGreen =>
      isDark
          ? AppColors.darkSuccess
          : AppColors.success;

  Color get successDark =>
      isDark
          ? AppColors.darkSuccessDark
          : AppColors.successDark;

  Color get gradientBlueLight =>
      isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get gradientBlueDark =>
      isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

  Color get streakOrange =>
      isDark
          ? AppColors.darkStreakOrange
          : AppColors.streakOrange;

  Color get streakLight =>
      isDark
          ? AppColors.darkStreakLight
          : AppColors.streakLight;

  Color get streakDark =>
      isDark
          ? AppColors.darkStreakDark
          : AppColors.streakDark;

  Color get progressBackground =>
      isDark
          ? AppColors.darkProgressBackground
          : AppColors.progressBackground;

  Color get xpOrange =>
      isDark
          ? AppColors.darkXpOrange
          : AppColors.xpOrange;

  Color get xpDark =>
      isDark
          ? AppColors.darkXpDark
          : AppColors.xpDark;

  // ============================================================
  // TIMER UPDATE
  // ============================================================

  void _timerUpdated() {
    if (!mounted) {
      return;
    }

    setState(() {});

    // ----------------------------------------------------------
    // SESSION COMPLETED
    // ----------------------------------------------------------

    if (timerService.isSessionCompleted(
      widget.habit,
    )) {
      final awardedXp = habitStore.lastAwardedXp;

      if (awardedXp > 0) {
        xpEarned = awardedXp;

        completionAnimationController.forward(from: 0);

        SystemSound.play(
          SystemSoundType.alert,
        );

        HapticFeedback.heavyImpact();
      }
    }
  }

  // ============================================================
  // START / RESUME
  // ============================================================

  void startTimer() {
    if (isHabitCompleted) {
      return;
    }

    timerService.start(widget.habit);
  }

  // ============================================================
  // PAUSE
  // ============================================================

  void pauseTimer() {
    timerService.pause(widget.habit);
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetTimer() {
    timerService.reset(widget.habit);

    xpEarned = 0;

    completionAnimationController.reset();

    setState(() {});
  }

  // ============================================================
  // CONTINUE TO NEXT UNIT
  // ============================================================

  void continueToNextUnit() {
    if (widget.habit.completed) {
      Navigator.pop(
        context,
        widget.habit,
      );

      return;
    }

    timerService.continueToNextUnit(
      widget.habit,
    );

    completionAnimationController.reset();

    setState(() {});
  }

  // ============================================================
  // TIMER
  // ============================================================

  String get formattedTime {
    final seconds = timerService.remainingSeconds(
      widget.habit,
    );

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  double get progressValue {
    if (widget.habit.goal <= 0) {
      return 0;
    }

    return (widget.habit.progress / widget.habit.goal)
        .clamp(0.0, 1.0);
  }

  // ============================================================
  // TIMER STATE
  // ============================================================

  bool get isRunning {
    return timerService.isRunning(
      widget.habit,
    );
  }

  bool get isSessionCompleted {
    return timerService.isSessionCompleted(
      widget.habit,
    );
  }

  int get remainingSeconds {
    return timerService.remainingSeconds(
      widget.habit,
    );
  }

  // ============================================================
  // HABIT COMPLETED
  // ============================================================

  bool get isHabitCompleted {
    return widget.habit.progress >= widget.habit.goal;
  }

  // ============================================================
  // EDIT HABIT
  // ============================================================

  Future<void> _editHabit() async {
    // Do not allow editing while timer is actively running.
    if (isRunning) {
      _showMessage(
        'Please pause the timer before editing the habit.',
        color: primaryBlue,
      );
      return;
    }

    final updatedHabit =
        await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (_) => AddHabitScreen(
          habit: widget.habit,
        ),
      ),
    );

    if (!mounted || updatedHabit == null) {
      return;
    }

    // Make sure completion is recalculated
    // after changing the goal.
    updatedHabit.completed =
        updatedHabit.progress >= updatedHabit.goal;

    await habitStore.update(
      updatedHabit,
    );

    if (!mounted) {
      return;
    }

    // Replace the values in the existing object so
    // the current detail screen immediately reflects
    // the edited habit.
    widget.habit.title =
        updatedHabit.title;

    widget.habit.subtitle =
        updatedHabit.subtitle;

    widget.habit.goal =
        updatedHabit.goal;

    widget.habit.progress =
        updatedHabit.progress;

    widget.habit.unit =
        updatedHabit.unit;

    widget.habit.timerMinutes =
        updatedHabit.timerMinutes;

    widget.habit.completed =
        updatedHabit.completed;

    widget.habit.streak =
        updatedHabit.streak;

    widget.habit.xp =
        updatedHabit.xp;

    widget.habit.lastCompletedDate =
        updatedHabit.lastCompletedDate;

    widget.habit.lastActivityDate =
        updatedHabit.lastActivityDate;

    widget.habit.lastXpDate =
        updatedHabit.lastXpDate;

    setState(() {});

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Habit updated successfully.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // DELETE HABIT
  // ============================================================

  Future<void> _deleteHabit() async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),

          title: Text(
            'Delete Habit?',
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            'Are you sure you want to delete '
            '"${widget.habit.title}"?\n\n'
            'This will permanently remove the '
            'habit and its saved progress.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
              height: 1.45,
            ),
          ),

          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFE05252),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    // User cancelled.
    if (confirmed != true) {
      return;
    }

    // Stop/reset any active timer for this habit.
    timerService.reset(
      widget.habit,
    );

    // Delete from store + database.
    await habitStore.delete(
      widget.habit.id,
    );

    if (!mounted) {
      return;
    }

    // Return to Home.
    Navigator.pop(
      context,
      null,
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: color ?? primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryBlue.withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        primaryBlue.withValues(
                      alpha: isDark ? 0.18 : 0.10,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: primaryText,
                  size: 22,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    widget.habit,
                  );
                },
              ),
            ),
          ),

          title: Text(
            'Habit Details',
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          centerTitle: true,

          // ====================================================
          // EDIT + DELETE BUTTONS
          // ====================================================

          actions: [
            // EDIT
            Container(
              width: 42,
              height: 42,
              margin:
                  const EdgeInsets.only(
                right: 8,
              ),
              decoration: BoxDecoration(
                color: cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      primaryBlue.withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        primaryBlue.withValues(
                      alpha: isDark ? 0.18 : 0.10,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Edit Habit',
                icon: Icon(
                  Icons.edit_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
                onPressed: _editHabit,
              ),
            ),

            // DELETE
            Container(
              width: 42,
              height: 42,
              margin:
                  const EdgeInsets.only(
                right: 12,
              ),
              decoration: BoxDecoration(
                color: cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      const Color(0xFFE05252)
                          .withValues(
                    alpha: 0.20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFFE05252)
                            .withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Delete Habit',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE05252),
                  size: 21,
                ),
                onPressed: _deleteHabit,
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: Stack(
          children: [
            // --------------------------------------------------
            // SOFT BLUE BACKGROUND GLOWS
            // --------------------------------------------------

            Positioned(
              top: -130,
              left: -110,
              child: _glow(
                size: 350,
                color: isDark
                    ? AppColors.darkBlueGlow
                    : AppColors.blueGlow,
                opacity: isDark ? 0.14 : 0.10,
              ),
            ),

            Positioned(
              top: 170,
              right: -160,
              child: _glow(
                size: 380,
                color: primaryBlue,
                opacity: isDark ? 0.10 : 0.08,
              ),
            ),

            Positioned(
              bottom: 50,
              left: -150,
              child: _glow(
                size: 360,
                color: primaryBlue,
                opacity: isDark ? 0.08 : 0.06,
              ),
            ),

            // --------------------------------------------------
            // CONTENT
            // --------------------------------------------------

            SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                35,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,

                children: [
                  // ============================================
                  // HABIT ICON
                  // ============================================

                  Container(
                    width: 88,
                    height: 88,
                    decoration:
                        BoxDecoration(
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
                        27,
                      ),
                      border: Border.all(
                        color:
                            brightBlue
                                .withValues(
                          alpha: 0.35,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              primaryBlue
                                  .withValues(
                            alpha: 0.20,
                          ),
                          blurRadius: 25,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
                      color: Colors.white,
                      size: 43,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ============================================
                  // TITLE
                  // ============================================

                  Text(
                    habit.title,
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 29,
                      fontWeight:
                          FontWeight.w800,
                      color: primaryText,
                      letterSpacing: -0.7,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // ============================================
                  // SUBTITLE
                  // ============================================

                  Text(
                    habit.subtitle,
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 14,
                      color: secondaryText,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ============================================
                  // PROGRESS CARD
                  // ============================================

                  _buildProgressCard(),

                  const SizedBox(height: 20),

                  // ============================================
                  // MAIN CONTENT
                  // ============================================

                  if (isHabitCompleted)
                    _habitCompletedCard()
                  else if (isSessionCompleted)
                    _sessionCompletedCard()
                  else
                    _timerCard(),

                  const SizedBox(height: 22),

                  // ============================================
                  // STREAK CARD
                  // ============================================

                  _buildStreakCard(),

                  const SizedBox(height: 22),

                  // ============================================
                  // BACK HOME
                  // ============================================

                  SizedBox(
                    width:
                        double.infinity,
                    height: 55,
                    child:
                        OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          widget.habit,
                        );
                      },
                      icon: const Icon(
                        Icons.home_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Back to Home',
                      ),
                      style:
                          OutlinedButton
                              .styleFrom(
                        foregroundColor:
                            primaryBlue,
                        side: BorderSide(
                          color:
                              primaryBlue
                                  .withValues(
                            alpha: 0.45,
                          ),
                          width: 1.2,
                        ),
                        backgroundColor:
                            primaryBlue
                                .withValues(
                          alpha: 0.04,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GLOW
  // ============================================================

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
              color.withValues(
                alpha: opacity,
              ),
              color.withValues(
                alpha: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS CARD
  // ============================================================

  Widget _buildProgressCard() {
    final percentage =
        (progressValue * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color:
              primaryBlue.withValues(
            alpha: 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withValues(
                        alpha: 0.20,
                      )
                    : AppColors.primaryText
                        .withValues(
                        alpha: 0.06,
                      ),
            blurRadius: 25,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      primaryBlue.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                  border: Border.all(
                    color:
                        primaryBlue.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: Text(
                  '$percentage%',
                  style:
                      TextStyle(
                    color: primaryBlue,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.habit.progress} / '
                '${widget.habit.goal} '
                '${widget.habit.unit}',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                isHabitCompleted
                    ? 'Completed'
                    : 'In progress',
                style: TextStyle(
                  color: isHabitCompleted
                      ? successGreen
                      : primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Container(
            height: 9,
            decoration:
                BoxDecoration(
              color:
                  progressBackground,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child:
                FractionallySizedBox(
              alignment:
                  Alignment.centerLeft,
              widthFactor:
                  progressValue,
              child: Container(
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors:
                        isHabitCompleted
                            ? [
                                AppColors.darkSuccessLight,
                                successDark,
                              ]
                            : [
                                gradientBlueDark,
                                gradientBlueLight,
                              ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isHabitCompleted
                              ? successGreen
                                  .withValues(
                                  alpha:
                                      0.35,
                                )
                              : primaryBlue
                                  .withValues(
                                  alpha:
                                      0.30,
                                ),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STREAK CARD
  // ============================================================

  Widget _buildStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration:
          BoxDecoration(
        color: cardBackground,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              streakOrange.withValues(
            alpha: 0.35,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                streakDark.withValues(
              alpha: 0.08,
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  streakLight,
                  streakDark,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      streakOrange
                          .withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const Icon(
              Icons
                  .local_fire_department_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Current Streak',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '${widget.habit.streak} days',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const Spacer(),

          const Text(
            '🔥',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIMER CARD
  // ============================================================

  Widget _timerCard() {
    final bool running = isRunning;

    final int remaining =
        remainingSeconds;

    final int configuredMinutes =
        widget.habit.timerMinutes;

    final bool hasPausedTime =
        !running && remaining > 0;

    return Column(
      children: [
        // ======================================================
        // TIMER DISPLAY
        // ======================================================

        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          decoration:
              BoxDecoration(
            color: cardBackground,
            borderRadius:
                BorderRadius.circular(
              27,
            ),
            border: Border.all(
              color:
                  primaryBlue.withValues(
                alpha: 0.18,
              ),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    primaryBlue.withValues(
                  alpha: isDark ? 0.16 : 0.10,
                ),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      gradientBlueLight,
                      gradientBlueDark,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          primaryBlue
                              .withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Icon(
                  running
                      ? Icons.timer_rounded
                      : Icons
                          .hourglass_empty_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                running || hasPausedTime
                    ? formattedTime
                    : '${configuredMinutes.toString().padLeft(2, '0')}:00',
                style:
                    TextStyle(
                  fontSize: 55,
                  fontWeight:
                      FontWeight.w800,
                  color: primaryText,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                running
                    ? 'Focus mode is running'
                    : hasPausedTime
                        ? 'Timer paused'
                        : 'Ready for the next '
                            '${_capitalize(widget.habit.unit)}?',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ======================================================
        // START / PAUSE / RESUME
        // ======================================================

        SizedBox(
          width: double.infinity,
          height: 56,
          child:
              ElevatedButton.icon(
            onPressed:
                running
                    ? pauseTimer
                    : startTimer,
            icon: Icon(
              running
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 22,
            ),
            label: Text(
              running
                  ? 'Pause'
                  : hasPausedTime
                      ? 'Resume'
                      : 'Start',
              style:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  primaryBlue,
              foregroundColor:
                  Colors.white,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ======================================================
        // RESET
        // ======================================================

        SizedBox(
          width: double.infinity,
          height: 51,
          child:
              OutlinedButton.icon(
            onPressed:
                resetTimer,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 20,
            ),
            label: const Text(
              'Reset Timer',
              style: TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  secondaryText,
              side: BorderSide(
                color:
                    primaryBlue
                        .withValues(
                  alpha: 0.25,
                ),
              ),
              backgroundColor:
                  primaryBlue
                      .withValues(
                alpha: 0.03,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SESSION COMPLETED CARD
  // ============================================================

  Widget _sessionCompletedCard() {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.75,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent:
              completionAnimationController,
          curve:
              Curves.elasticOut,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 105,
            height: 105,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  gradientBlueLight,
                  gradientBlueDark,
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    primaryBlue.withValues(
                  alpha: 0.30,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      primaryBlue
                          .withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 28,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🎉',
                style: TextStyle(
                  fontSize: 52,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Session Complete!',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 29,
              fontWeight:
                  FontWeight.w800,
              color: primaryText,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '${widget.habit.progress} / '
            '${widget.habit.goal} '
            '${widget.habit.unit} completed',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: secondaryText,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              21,
            ),
            decoration:
                BoxDecoration(
              color: cardBackground,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
              border: Border.all(
                color:
                    primaryBlue.withValues(
                  alpha: 0.20,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      primaryBlue
                          .withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 22,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  xpEarned > 0
                      ? '⭐ +$xpEarned XP'
                      : '⭐ Session Complete',
                  style:
                      TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w800,
                    color: xpOrange,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  xpEarned > 0
                      ? 'Great job! Keep going.'
                      : 'Keep working toward your daily goal.',
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child:
                ElevatedButton(
              onPressed:
                  continueToNextUnit,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryBlue,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                ),
              ),
              child: Text(
                widget.habit.progress >=
                        widget.habit.goal
                    ? 'View Completed Habit'
                    : 'Continue to Next '
                        '${_capitalize(widget.habit.unit)}',
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HABIT COMPLETED
  // ============================================================

  Widget _habitCompletedCard() {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.75,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent:
              completionAnimationController,
          curve:
              Curves.elasticOut,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),

          Container(
            width: 115,
            height: 115,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  successGreen,
                  successDark,
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    successGreen
                        .withValues(
                  alpha: 0.50,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      successGreen
                          .withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 28,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🏆',
                style: TextStyle(
                  fontSize: 58,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Habit Completed!',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.w800,
              color: primaryText,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'You completed all '
            '${widget.habit.goal} '
            '${widget.habit.unit}!',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: secondaryText,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              21,
            ),
            decoration:
                BoxDecoration(
              color: cardBackground,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
              border: Border.all(
                color:
                    successGreen
                        .withValues(
                  alpha: 0.30,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      successGreen
                          .withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 22,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  xpEarned > 0
                      ? '⭐ +$xpEarned XP'
                      : '⭐ XP Earned',
                  style:
                      TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w800,
                    color: xpOrange,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Amazing work! 🎉',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CAPITALIZE
  // ============================================================

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}