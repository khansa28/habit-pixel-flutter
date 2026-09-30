import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class EmptyHabitsState extends StatelessWidget {
  const EmptyHabitsState({
    super.key,
    required this.onCreateHabit,
  });

  final VoidCallback onCreateHabit;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    final cardBackground = isDark
        ? AppColors.darkCardBackground
        : AppColors.cardBackground;

    final backgroundBottom = isDark
        ? AppColors.darkSoftBlue
        : AppColors.backgroundBottom;

    final primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

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

    final border = isDark
        ? AppColors.darkCardBorder
        : AppColors.cardBorder;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardBackground,
            backgroundBottom,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: primaryBlue.withValues(
            alpha: isDark ? 0.35 : 0.25,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(
              alpha: isDark ? 0.16 : 0.09,
            ),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradientBlueLight,
                  gradientBlueDark,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(
                    alpha: isDark ? 0.35 : 0.25,
                  ),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Start your journey by creating your first habit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            onPressed: onCreateHabit,
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: const Text(
              'Create Habit',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
