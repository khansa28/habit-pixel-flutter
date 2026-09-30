import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class HabitBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const HabitBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  // ============================================================
  // NAV ITEMS
  // ============================================================

  static const List<_NavItem> items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.branding_watermark_outlined,
      activeIcon: Icons.branding_watermark_rounded,
      label: 'Brand',
    ),
    _NavItem(
      icon: Icons.sports_esports_outlined,
      activeIcon: Icons.sports_esports_rounded,
      label: 'Games',
    ),
    _NavItem(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events_rounded,
      label: 'Achievements',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeController.instance.isDarkMode;

    final Color navBackground = isDark
        ? AppColors.darkCardBackground
        : AppColors.cardBackground;

    final Color primaryBlue = isDark
        ? AppColors.darkPrimaryBlue
        : AppColors.primaryBlue;

    final Color brightBlue = isDark
        ? AppColors.darkBrightBlue
        : AppColors.brightBlue;

    final Color secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.secondaryText;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: navBackground,
        border: Border(
          top: BorderSide(
            color: primaryBlue.withValues(alpha: isDark ? 0.18 : 0.10),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: isDark ? 0.14 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];

            final bool isSelected = currentIndex == index;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onItemSelected(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              brightBlue.withValues(
                                alpha: isDark ? 0.20 : 0.13,
                              ),
                              primaryBlue.withValues(
                                alpha: isDark ? 0.10 : 0.055,
                              ),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(
                            color: primaryBlue.withValues(
                              alpha: isDark ? 0.25 : 0.14,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ==================================================
                      // ICON
                      // ==================================================

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: isSelected ? 38 : 30,
                        height: isSelected ? 30 : 26,
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : Colors.transparent,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primaryBlue.withValues(
                                      alpha: isDark ? 0.35 : 0.22,
                                    ),
                                    blurRadius: 11,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 21,
                          color: isSelected ? Colors.white : secondaryText,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ==================================================
                      // LABEL
                      // ==================================================
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          color: isSelected ? primaryBlue : secondaryText,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================
// NAV ITEM MODEL
// ============================================================

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
