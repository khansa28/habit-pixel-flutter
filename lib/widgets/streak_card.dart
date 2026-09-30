
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.currentStreak,
  });

  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        ThemeController.instance.isDarkMode;

    final Color cardBackground = isDark
        ? AppColors.darkCardBackground
        : AppColors.cardBackground;

    final Color cardGradientEnd = isDark
        ? AppColors.darkBackgroundBottom
        : const Color(0xFFFFF7F0);

    final Color borderColor = isDark
        ? AppColors.darkStreakLight
        : AppColors.streakLight;

    final Color shadowColor = isDark
        ? AppColors.darkStreakDark
        : AppColors.streakDark;

    final Color streakLight = isDark
        ? AppColors.darkStreakLight
        : AppColors.streakLight;

    final Color streakDark = isDark
        ? AppColors.darkStreakDark
        : AppColors.streakDark;

    final Color primaryText = isDark
        ? AppColors.darkPrimaryText
        : AppColors.primaryText;

    final Color secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.secondaryText;

    return Container(
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
          color: borderColor.withValues(
            alpha: isDark ? 0.55 : 0.45,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(
              alpha: isDark ? 0.18 : 0.09,
            ),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  streakLight,
                  streakDark,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: streakDark.withValues(
                    alpha: isDark ? 0.35 : 0.25,
                  ),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            '$currentStreak',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            'Best streak',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

