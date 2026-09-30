
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class HomeFloatingButton extends StatelessWidget {
  const HomeFloatingButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        ThemeController.instance.isDarkMode;

    final Color gradientLight = isDark
        ? AppColors.darkGradientBlueLight
        : AppColors.gradientBlueLight;

    final Color gradientDark = isDark
        ? AppColors.darkGradientBlueDark
        : AppColors.gradientBlueDark;

    final Color primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

    final Color borderColor = isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFB8DEFF);

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientLight,
            gradientDark,
          ],
        ),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(
              alpha: isDark ? 0.42 : 0.30,
            ),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
