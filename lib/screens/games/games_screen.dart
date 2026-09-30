import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';
import '../../widgets/games/game_card.dart';
import 'chess_screen.dart';
import 'snake_screen.dart';
import 'tic_tac_toe_screen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() =>
      _GamesScreenState();
}

class _GamesScreenState
    extends State<GamesScreen> {
  // ============================================================
  // THEME
  // ============================================================

  bool get _isDark =>
      ThemeController.instance.isDarkMode;

  Color get _backgroundTop =>
      _isDark
          ? AppColors.darkBackgroundTop
          : AppColors.backgroundTop;

  Color get _backgroundMiddle =>
      _isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  Color get _backgroundBottom =>
      _isDark
          ? AppColors.darkBackgroundBottom
          : AppColors.backgroundBottom;

  Color get _primaryBlue =>
      _isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get _primaryText =>
      _isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get _secondaryText =>
      _isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get _blueGlow =>
      _isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  Color get _violetGlow =>
      _isDark
          ? AppColors.darkVioletGlow
          : AppColors.violetGlow;

  Color get _cardBackground =>
      _isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get _cardBorder =>
      _isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get _gradientBlueLight =>
      _isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get _gradientBlueDark =>
      _isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

  Color get _gradientVioletLight =>
      _isDark
          ? AppColors.darkGradientVioletLight
          : AppColors.gradientVioletLight;

  Color get _gradientVioletDark =>
      _isDark
          ? AppColors.darkGradientVioletDark
          : AppColors.gradientVioletDark;

  // ============================================================
  // INIT / DISPOSE
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _themeChanged,
    );
  }

  void _themeChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(
      _themeChanged,
    );

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
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

        // ============================================================
        // APP BAR
        // ============================================================

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 20,

          title: Text(
            'Games',
            style: TextStyle(
              color: _primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // ============================================================
        // BODY
        // ============================================================

        body: Stack(
          children: [
            // ========================================================
            // TOP BLUE GLOW
            // ========================================================

            Positioned(
              top: -100,
              right: -120,
              child: _glow(
                size: 300,
                color: _blueGlow,
                opacity: _isDark
                    ? 0.16
                    : 0.13,
              ),
            ),

            // ========================================================
            // BOTTOM VIOLET GLOW
            // ========================================================

            Positioned(
              bottom: -150,
              left: -120,
              child: _glow(
                size: 330,
                color: _violetGlow,
                opacity: _isDark
                    ? 0.13
                    : 0.10,
              ),
            ),

            // ========================================================
            // CONTENT
            // ========================================================

            SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                110,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  Text(
                    'Take a little break 🎮',
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: -0.7,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    'Play, relax, and keep your streak alive.',
                    style: TextStyle(
                      color: _secondaryText,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ==================================================
                  // TIC TAC TOE
                  // ==================================================

                  GameCard(
                    title: 'Tic-Tac-Toe',
                    subtitle:
                        'Challenge the AI and get three in a row.',
                    icon: Icons.close_rounded,
                    colors: [
                      _gradientBlueDark,
                      _gradientBlueLight,
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TicTacToeScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================================
                  // SNAKE
                  // ==================================================

                  GameCard(
                    title: 'Snake',
                    subtitle:
                        'Eat, grow, and beat your highest score.',
                    icon: Icons.gesture_rounded,
                    colors: [
                      _gradientVioletDark,
                      _gradientVioletLight,
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SnakeScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================================
                  // CHESS
                  // ==================================================

                  GameCard(
                    title: 'Chess',
                    subtitle:
                        'Play a classic game of strategy and skill.',
                    icon: Icons.grid_4x4_rounded,
                    colors: [
                      _isDark
                          ? AppColors.darkGradientCyanDark
                          : AppColors.gradientCyanDark,
                      _isDark
                          ? AppColors.darkGradientCyanLight
                          : AppColors.gradientCyanLight,
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ChessScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // MORE GAMES
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                        BoxDecoration(
                      color: _cardBackground
                          .withValues(
                        alpha:
                            _isDark
                                ? 0.92
                                : 0.75,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      border: Border.all(
                        color: _cardBorder
                            .withValues(
                          alpha:
                              _isDark
                                  ? 0.75
                                  : 0.15,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color:
                              _isDark
                                  ? AppColors
                                      .darkXpOrange
                                  : AppColors.xpOrange,
                          size: 25,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            'More games are coming soon!',
                            style: TextStyle(
                              color:
                                  _primaryText,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  // ================================================================
  // BACKGROUND GLOW
  // ================================================================

  Widget _glow({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,

        decoration:
            BoxDecoration(
          shape: BoxShape.circle,

          gradient:
              RadialGradient(
            colors: [
              color.withValues(
                alpha: opacity,
              ),
              color.withValues(
                alpha: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}