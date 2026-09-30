import 'package:flutter/material.dart';

import '../services/habit_store.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class XpCard extends StatelessWidget {
  const XpCard({
    super.key,
    required this.habitStore,
  });

  final HabitStore habitStore;

  @override
  Widget build(BuildContext context) {
    final int xp = habitStore.totalXp;
    final int level = habitStore.currentLevel;
    final double progress = habitStore.levelProgress;
    final int xpNeeded = habitStore.xpNeededForNextLevel;

    final int nextLevel = level + 1;
    final int percentage = (progress * 100).round();

    final bool isDark =
        ThemeController.instance.isDarkMode;

    final Color cardBackground = isDark
        ? AppColors.darkCardBackground
        : AppColors.cardBackground;

    final Color cardGradientEnd = isDark
        ? AppColors.darkBackgroundBottom
        : AppColors.backgroundBottom;

    final Color primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

    final Color primaryText = isDark
        ? AppColors.darkPrimaryText
        : AppColors.primaryText;

    final Color secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.secondaryText;

    final Color cardBorder = isDark
        ? AppColors.darkCardBorder
        : AppColors.cardBorder;

    final Color progressBackground = isDark
        ? AppColors.darkProgressBackground
        : AppColors.progressBackground;

    final Color gradientBlueLight = isDark
        ? AppColors.darkGradientBlueLight
        : AppColors.gradientBlueLight;

    final Color gradientBlueDark = isDark
        ? AppColors.darkGradientBlueDark
        : AppColors.gradientBlueDark;

    final Color xpOrange = isDark
        ? AppColors.darkXpOrange
        : AppColors.xpOrange;

    final Color xpDark = isDark
        ? AppColors.darkXpDark
        : AppColors.xpDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardBackground,
            cardGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: primaryBlue.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(
              alpha: isDark ? 0.18 : 0.10,
            ),
            blurRadius: 25,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gradientBlueLight,
                          gradientBlueDark,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withValues(
                            alpha: isDark ? 0.35 : 0.25,
                          ),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEVEL $level',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level == 1
                            ? 'Start your journey!'
                            : 'Keep leveling up!',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: xpOrange.withValues(
                    alpha: isDark ? 0.14 : 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: xpOrange.withValues(
                      alpha: isDark ? 0.40 : 0.35,
                    ),
                  ),
                ),
                child: Text(
                  '⭐ $xp XP',
                  style: TextStyle(
                    color: xpDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress to Level $nextLevel',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Container(
            height: 9,
            decoration: BoxDecoration(
              color: progressBackground,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientBlueDark,
                      gradientBlueLight,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withValues(
                        alpha: isDark ? 0.40 : 0.30,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$xpNeeded XP needed to reach Level $nextLevel',
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

