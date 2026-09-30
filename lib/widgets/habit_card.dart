
import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
  });

  final Habit habit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final habitProgress = habit.goal <= 0
        ? 0.0
        : (habit.progress / habit.goal).clamp(0.0, 1.0);

    final isCompleted = habit.completed;
    final isDark =
        ThemeController.instance.isDarkMode;

    final Color cardBackground = isDark
        ? AppColors.darkCardBackground
        : AppColors.cardBackground;

    final Color cardGradientEnd = isDark
        ? AppColors.darkBackgroundBottom
        : AppColors.backgroundMiddle;

    final Color primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

    final Color primaryText = isDark
        ? AppColors.darkPrimaryText
        : AppColors.primaryText;

    final Color secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.secondaryText;

    final Color mutedText = isDark
        ? AppColors.darkMutedText
        : AppColors.mutedText;

    final Color softBlue = isDark
        ? AppColors.darkSoftBlue
        : AppColors.softBlue;

    final Color progressBackground = isDark
        ? AppColors.darkProgressBackground
        : AppColors.progressBackground;

    final Color success = isDark
        ? AppColors.darkSuccess
        : AppColors.success;

    final Color successDark = isDark
        ? AppColors.darkSuccessDark
        : AppColors.successDark;

    final Color successLight = isDark
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    final Color streakOrange = isDark
        ? AppColors.darkStreakOrange
        : AppColors.streakOrange;

    final Color gradientBlueLight = isDark
        ? AppColors.darkGradientBlueLight
        : AppColors.gradientBlueLight;

    final Color gradientBlueDark = isDark
        ? AppColors.darkGradientBlueDark
        : AppColors.gradientBlueDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
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
            color: isCompleted
                ? success.withValues(
                    alpha: isDark ? 0.55 : 0.45,
                  )
                : primaryBlue.withValues(
                    alpha: isDark ? 0.35 : 0.22,
                  ),
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? success.withValues(
                      alpha: isDark ? 0.16 : 0.09,
                    )
                  : primaryBlue.withValues(
                      alpha: isDark ? 0.16 : 0.09,
                    ),
              blurRadius: 22,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientBlueLight,
                        gradientBlueDark,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryBlue.withValues(
                        alpha: isDark ? 0.35 : 0.25,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withValues(
                          alpha: isDark ? 0.32 : 0.22,
                        ),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.track_changes_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w700,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        habit.subtitle,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${habit.progress} / ${habit.goal} ${habit.unit}',
                        style: TextStyle(
                          color: isCompleted
                              ? successDark
                              : primaryBlue,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? success
                        : softBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? success
                          : primaryBlue.withValues(
                              alpha:
                                  isDark
                                      ? 0.40
                                      : 0.30,
                            ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isCompleted
                            ? success.withValues(
                                alpha:
                                    isDark
                                        ? 0.40
                                        : 0.30,
                              )
                            : primaryBlue.withValues(
                                alpha:
                                    isDark
                                        ? 0.16
                                        : 0.10,
                              ),
                        blurRadius:
                            isCompleted ? 18 : 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : Icons.circle_outlined,
                    color: isCompleted
                        ? Colors.white
                        : mutedText,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${habit.progress} / ${habit.goal} ${habit.unit}',
                  style: TextStyle(
                    color: isCompleted
                        ? successDark
                        : primaryBlue,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                Row(
                  children: [
                    Icon(
                      Icons
                          .local_fire_department_rounded,
                      size: 16,
                      color: streakOrange,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${habit.streak}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              height: 7,
              decoration: BoxDecoration(
                color: progressBackground,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: FractionallySizedBox(
                alignment:
                    Alignment.centerLeft,
                widthFactor: habitProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCompleted
                          ? [
                              success,
                              successLight,
                            ]
                          : [
                              gradientBlueDark,
                              gradientBlueLight,
                            ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isCompleted
                            ? success.withValues(
                                alpha:
                                    isDark
                                        ? 0.40
                                        : 0.30,
                              )
                            : primaryBlue.withValues(
                                alpha:
                                    isDark
                                        ? 0.40
                                        : 0.30,
                              ),
                        blurRadius: 10,
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
