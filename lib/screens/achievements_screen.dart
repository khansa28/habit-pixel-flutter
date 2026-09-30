import 'package:flutter/material.dart';

import '../services/habit_store.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() =>
      _AchievementsScreenState();
}

class _AchievementsScreenState
    extends State<AchievementsScreen> {
  // ============================================================
  // STORE
  // ============================================================

  final HabitStore habitStore = HabitStore.instance;

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

  Color get deepBlue =>
      isDark
          ? AppColors.darkDeepBlue
          : AppColors.deepBlue;

  Color get softBlue =>
      isDark
          ? AppColors.darkSoftBlue
          : AppColors.softBlue;

  Color get primaryText =>
      isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get secondaryText =>
      isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get mutedText =>
      isDark
          ? AppColors.darkMutedText
          : AppColors.mutedText;

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

  Color get successLight =>
      isDark
          ? AppColors.darkSuccessLight
          : AppColors.successLight;

  Color get streakOrange =>
      isDark
          ? AppColors.darkStreakOrange
          : AppColors.streakOrange;

  Color get xpOrange =>
      isDark
          ? AppColors.darkXpOrange
          : AppColors.xpOrange;

  Color get xpDark =>
      isDark
          ? AppColors.darkXpDark
          : AppColors.xpDark;

  Color get progressBackground =>
      isDark
          ? AppColors.darkProgressBackground
          : AppColors.progressBackground;

  Color get gradientBlueLight =>
      isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get gradientBlueDark =>
      isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

  Color get gradientCyanLight =>
      isDark
          ? AppColors.darkGradientCyanLight
          : AppColors.gradientCyanLight;

  Color get gradientCyanDark =>
      isDark
          ? AppColors.darkGradientCyanDark
          : AppColors.gradientCyanDark;

  Color get gradientVioletLight =>
      isDark
          ? AppColors.darkGradientVioletLight
          : AppColors.gradientVioletLight;

  Color get gradientVioletDark =>
      isDark
          ? AppColors.darkGradientVioletDark
          : AppColors.gradientVioletDark;

  Color get blueGlow =>
      isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  Color get cyanGlow =>
      isDark
          ? AppColors.darkCyanGlow
          : AppColors.cyanGlow;

  Color get violetGlow =>
      isDark
          ? AppColors.darkVioletGlow
          : AppColors.violetGlow;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    habitStore.addListener(_refresh);
    ThemeController.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    habitStore.removeListener(_refresh);
    ThemeController.instance.removeListener(_refresh);

    super.dispose();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // GETTERS
  // ============================================================

  int get totalXp => habitStore.totalXp;

  int get currentLevel => habitStore.currentLevel;

  int get totalHabits => habitStore.totalHabits;

  int get completedHabits =>
      habitStore.completedHabits;

  int get bestStreak => habitStore.bestStreak;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final achievements = _buildAchievements();

    final unlockedCount = achievements
        .where(
          (achievement) => achievement.unlocked,
        )
        .length;

    final totalCount = achievements.length;

    final overallProgress =
        totalCount == 0
            ? 0.0
            : unlockedCount / totalCount;

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
          titleSpacing: 20,

          title: Text(
            'Achievements',
            style: TextStyle(
              color: primaryText,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 18,
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cardBackground.withValues(
                    alpha: isDark ? 0.95 : 0.82,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryBlue.withValues(
                      alpha: 0.20,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withValues(
                        alpha: isDark ? 0.20 : 0.12,
                      ),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: xpOrange,
                  size: 23,
                ),
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
            // BLUE GLOW — TOP RIGHT
            // --------------------------------------------------

            Positioned(
              top: -100,
              right: -130,
              child: _glow(
                size: 330,
                color: blueGlow,
                opacity: isDark ? 0.16 : 0.14,
              ),
            ),

            // --------------------------------------------------
            // VIOLET GLOW — LEFT
            // --------------------------------------------------

            Positioned(
              top: 360,
              left: -160,
              child: _glow(
                size: 350,
                color: violetGlow,
                opacity: isDark ? 0.12 : 0.10,
              ),
            ),

            // --------------------------------------------------
            // CYAN GLOW — BOTTOM RIGHT
            // --------------------------------------------------

            Positioned(
              bottom: -170,
              right: -140,
              child: _glow(
                size: 370,
                color: cyanGlow,
                opacity: isDark ? 0.10 : 0.08,
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
                8,
                20,
                35,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // INTRO
                  // ==================================================

                  Text(
                    'Keep achieving 🏆',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Every milestone brings you one step closer.',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // SUMMARY
                  // ==================================================

                  _buildSummaryCard(
                    unlockedCount,
                    totalCount,
                    overallProgress,
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // SECTION HEADER
                  // ==================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Achievements',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: softBlue,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                          border: Border.all(
                            color:
                                primaryBlue.withValues(
                              alpha: 0.20,
                            ),
                          ),
                        ),
                        child: Text(
                          '$unlockedCount / $totalCount',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // ACHIEVEMENT CARDS
                  // ==================================================

                  ...achievements.map(
                    (achievement) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 13,
                      ),
                      child:
                          _buildAchievementCard(
                        achievement,
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
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard(
    int unlocked,
    int total,
    double progress,
  ) {
    final percentage =
        (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardBackground,
            softBlue,
          ],
        ),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: primaryBlue.withValues(
            alpha: 0.30,
          ),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: blueGlow.withValues(
              alpha: isDark ? 0.15 : 0.10,
            ),
            blurRadius: 26,
            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              // ------------------------------------------------
              // TROPHY
              // ------------------------------------------------

              Container(
                width: 56,
                height: 56,

                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientCyanLight,
                      gradientBlueDark,
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(17),

                  boxShadow: [
                    BoxShadow(
                      color:
                          blueGlow.withValues(
                        alpha: isDark ? 0.25 : 0.20,
                      ),
                      blurRadius: 20,
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              // ------------------------------------------------
              // TEXT
              // ------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievement Progress',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '$unlocked of $total achievements unlocked',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // PERCENTAGE
              // ------------------------------------------------

              Text(
                '$percentage%',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------
          // PROGRESS BAR
          // ----------------------------------------------------

          Container(
            height: 9,
            width: double.infinity,

            decoration: BoxDecoration(
              color: progressBackground,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: FractionallySizedBox(
              alignment:
                  Alignment.centerLeft,

              widthFactor: progress,

              child: Container(
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      gradientBlueLight,
                      gradientBlueDark,
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color:
                          blueGlow.withValues(
                        alpha: isDark ? 0.30 : 0.24,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // QUICK STATS
          // ----------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _summaryStat(
                  Icons.bolt_rounded,
                  '$totalXp',
                  'Total XP',
                  xpOrange,
                ),
              ),

              Container(
                width: 1,
                height: 35,
                color:
                    primaryBlue.withValues(
                  alpha: 0.18,
                ),
              ),

              Expanded(
                child: _summaryStat(
                  Icons.star_rounded,
                  '$currentLevel',
                  'Level',
                  gradientVioletLight,
                ),
              ),

              Container(
                width: 1,
                height: 35,
                color:
                    primaryBlue.withValues(
                  alpha: 0.18,
                ),
              ),

              Expanded(
                child: _summaryStat(
                  Icons.local_fire_department_rounded,
                  '$bestStreak',
                  'Best streak',
                  streakOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY STAT
  // ============================================================

  Widget _summaryStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 19,
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: TextStyle(
            color: primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 1),

        Text(
          label,
          style: TextStyle(
            color: mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACHIEVEMENT CARD
  // ============================================================

  Widget _buildAchievementCard(
    Achievement achievement,
  ) {
    final unlocked = achievement.unlocked;

    final lockedBackground =
        isDark
            ? AppColors.darkBackgroundMiddle
            : AppColors.backgroundMiddle;

    final lockedBorder =
        isDark
            ? AppColors.darkCardBorder
            : AppColors.cardBorder;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 250),

      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: unlocked
              ? [
                  cardBackground,
                  achievement.color
                      .withValues(
                    alpha: isDark ? 0.12 : 0.08,
                  ),
                ]
              : [
                  cardBackground,
                  lockedBackground,
                ],
        ),

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: unlocked
              ? achievement.color.withValues(
                  alpha: isDark ? 0.50 : 0.38,
                )
              : lockedBorder,

          width: unlocked ? 1.2 : 1,
        ),

        boxShadow: [
          BoxShadow(
            color: unlocked
                ? achievement.color.withValues(
                    alpha: isDark ? 0.16 : 0.10,
                  )
                : primaryBlue.withValues(
                    alpha: isDark ? 0.04 : 0.03,
                  ),

            blurRadius: 20,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          // ======================================================
          // ACHIEVEMENT ICON
          // ======================================================

          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: [
                        achievement.color
                            .withValues(
                          alpha: isDark ? 0.82 : 0.72,
                        ),
                        achievement.color,
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        progressBackground,
                        isDark
                            ? AppColors.darkCardBorder
                            : AppColors.cardBorder,
                      ],
                    ),

              borderRadius:
                  BorderRadius.circular(18),

              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: achievement.color
                            .withValues(
                          alpha: isDark ? 0.28 : 0.18,
                        ),
                        blurRadius: 18,
                      ),
                    ]
                  : null,
            ),

            child: Icon(
              unlocked
                  ? achievement.icon
                  : Icons.lock_outline_rounded,

              color: unlocked
                  ? Colors.white
                  : mutedText,

              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          // ======================================================
          // ACHIEVEMENT INFORMATION
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color: unlocked
                              ? primaryText
                              : secondaryText,

                          fontSize: 15,

                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),

                    if (unlocked)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration:
                            BoxDecoration(
                          color: successGreen
                              .withValues(
                            alpha: 0.12,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            9,
                          ),
                        ),

                        child: Text(
                          'UNLOCKED',

                          style: TextStyle(
                            color:
                                successDark,

                            fontSize: 8.5,

                            fontWeight:
                                FontWeight.w800,

                            letterSpacing:
                                0.3,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  achievement.description,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color: unlocked
                        ? secondaryText
                        : mutedText,

                    fontSize: 11.5,

                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,

                      size: 15,

                      color: unlocked
                          ? successGreen
                          : mutedText,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      unlocked
                          ? 'Milestone achieved'
                          : 'Milestone',

                      style: TextStyle(
                        color: unlocked
                            ? successDark
                            : mutedText,

                        fontSize: 11,

                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    if (!unlocked)
                      Flexible(
                        child: Text(
                          achievement.requirement,

                          textAlign:
                              TextAlign.right,

                          style: TextStyle(
                            color: mutedText,

                            fontSize: 10,

                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACHIEVEMENT DATA
  // ============================================================

  List<Achievement> _buildAchievements() {
    return [
      // --------------------------------------------------------
      // FIRST STEP
      // --------------------------------------------------------

      Achievement(
        title: 'First Step',

        description:
            'Create your very first habit and begin your journey.',

        requirement:
            '$totalHabits / 1 habit',

        icon: Icons.flag_rounded,

        color: gradientCyanLight,

        unlocked:
            habitStore.isAchievementUnlocked(
          'first_step',
        ),
      ),

      // --------------------------------------------------------
      // GETTING STARTED
      // --------------------------------------------------------

      Achievement(
        title: 'Getting Started',

        description:
            'Create three habits and build your routine.',

        requirement:
            '$totalHabits / 3 habits',

        icon: Icons.auto_awesome_rounded,

        color: gradientVioletLight,

        unlocked:
            habitStore.isAchievementUnlocked(
          'getting_started',
        ),
      ),

      // --------------------------------------------------------
      // HABIT BUILDER
      // --------------------------------------------------------

      Achievement(
        title: 'Habit Builder',

        description:
            'Create five habits and become more consistent.',

        requirement:
            '$totalHabits / 5 habits',

        icon: Icons.construction_rounded,

        color: brightBlue,

        unlocked:
            habitStore.isAchievementUnlocked(
          'habit_builder',
        ),
      ),

      // --------------------------------------------------------
      // FIRST WIN
      // --------------------------------------------------------

      Achievement(
        title: 'First Win',

        description:
            'Complete your first habit for the day.',

        requirement:
            '$completedHabits / 1 completed',

        icon: Icons.check_circle_rounded,

        color: successLight,

        unlocked:
            habitStore.isAchievementUnlocked(
          'first_win',
        ),
      ),

      // --------------------------------------------------------
      // DAILY CHAMPION
      // --------------------------------------------------------

      Achievement(
        title: 'Daily Champion',

        description:
            'Complete all your habits in a single day.',

        requirement:
            habitsCompletedRequirement(),

        icon: Icons.emoji_events_rounded,

        color: xpOrange,

        unlocked:
            habitStore.isAchievementUnlocked(
          'daily_champion',
        ),
      ),

      // --------------------------------------------------------
      // STREAK STARTER
      // --------------------------------------------------------

      Achievement(
        title: 'Streak Starter',

        description:
            'Build your first three-day habit streak.',

        requirement:
            '$bestStreak / 3 days',

        icon: Icons.local_fire_department_rounded,

        color: streakOrange,

        unlocked:
            habitStore.isAchievementUnlocked(
          'streak_starter',
        ),
      ),

      // --------------------------------------------------------
      // ON FIRE
      // --------------------------------------------------------

      Achievement(
        title: 'On Fire',

        description:
            'Reach a seven-day streak on a habit.',

        requirement:
            '$bestStreak / 7 days',

        icon: Icons.local_fire_department_rounded,

        color: AppColors.streakLight,

        unlocked:
            habitStore.isAchievementUnlocked(
          'on_fire',
        ),
      ),

      // --------------------------------------------------------
      // LEVEL UP
      // --------------------------------------------------------

      Achievement(
        title: 'Level Up',

        description:
            'Reach Level 5 through consistent progress.',

        requirement:
            'Level $currentLevel / Level 5',

        icon: Icons.bolt_rounded,

        color: gradientVioletDark,

        unlocked:
            habitStore.isAchievementUnlocked(
          'level_up',
        ),
      ),

      // --------------------------------------------------------
      // XP MASTER
      // --------------------------------------------------------

      Achievement(
        title: 'XP Master',

        description:
            'Earn 1,000 total XP through your habits.',

        requirement:
            '$totalXp / 1000 XP',

        icon: Icons.stars_rounded,

        color: xpOrange,

        unlocked:
            habitStore.isAchievementUnlocked(
          'xp_master',
        ),
      ),
    ];
  }

  // ============================================================
  // DAILY REQUIREMENT TEXT
  // ============================================================

  String habitsCompletedRequirement() {
    if (totalHabits == 0) {
      return '0 / 0 completed';
    }

    return '$completedHabits / $totalHabits completed';
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
}

// ================================================================
// ACHIEVEMENT MODEL
// ================================================================

class Achievement {
  final String title;

  final String description;

  final String requirement;

  final IconData icon;

  final Color color;

  final bool unlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.requirement,
    required this.icon,
    required this.color,
    required this.unlocked,
  });
}