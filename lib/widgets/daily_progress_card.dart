
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).round();

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

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
              alpha: isDark ? 0.16 : 0.10,
            ),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradientBlueLight,
                  gradientBlueDark,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
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
              Icons.check_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            'Today',
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
