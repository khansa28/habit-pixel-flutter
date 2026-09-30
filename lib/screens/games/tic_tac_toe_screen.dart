import 'dart:math';

import 'package:flutter/material.dart';

import '../../services/habit_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() =>
      _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // ============================================================
  // THEME
  // ============================================================

  bool get _isDark =>
      ThemeController.instance.isDarkMode;

  Color get _primaryBlue =>
      _isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get _brightBlue =>
      _isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get _deepBlue =>
      _isDark
          ? AppColors.darkDeepBlue
          : AppColors.deepBlue;

  Color get _purple =>
      _isDark
          ? AppColors.darkNeonViolet
          : AppColors.neonViolet;

  Color get _brightPurple =>
      _isDark
          ? AppColors.darkGradientVioletLight
          : AppColors.gradientVioletLight;

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

  Color get _primaryText =>
      _isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get _secondaryText =>
      _isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get _mutedText =>
      _isDark
          ? AppColors.darkMutedText
          : AppColors.mutedText;

  Color get _cardBackground =>
      _isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get _cardBorder =>
      _isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get _progressBackground =>
      _isDark
          ? AppColors.darkProgressBackground
          : AppColors.progressBackground;

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

  Color get _xpOrange =>
      _isDark
          ? AppColors.darkXpOrange
          : AppColors.xpOrange;

  Color get _xpDark =>
      _isDark
          ? AppColors.darkXpDark
          : AppColors.xpDark;

  Color get _streakOrange =>
      _isDark
          ? AppColors.darkStreakOrange
          : AppColors.streakOrange;

  Color get _blueGlow =>
      _isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  // ============================================================
  // GAME XP
  // ============================================================

  // These values come from the central HabitStore.
  //
  // Win  -> +30 XP
  // Draw -> +10 XP
  // Loss -> +0 XP

  final HabitStore _habitStore =
      HabitStore.instance;

  // ============================================================
  // GAME VARIABLES
  // ============================================================

  final Random _random = Random();

  List<String> board = List.filled(
    9,
    '',
  );

  bool playerTurn = true;
  bool gameOver = false;
  bool aiThinking = false;

  int playerScore = 0;
  int aiScore = 0;
  int drawScore = 0;

  // ============================================================
  // WINNING COMBINATIONS
  // ============================================================

  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  // ============================================================
  // THEME LISTENER
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _themeChanged,
    );
  }

  void _themeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(
      _themeChanged,
    );

    super.dispose();
  }

  // ============================================================
  // PLAYER MOVE
  // ============================================================

  void _playerMove(
    int index,
  ) {
    if (!playerTurn ||
        gameOver ||
        aiThinking ||
        board[index].isNotEmpty) {
      return;
    }

    setState(() {
      board[index] = 'X';
      playerTurn = false;
    });

    if (_checkGameResult('X')) {
      return;
    }

    _aiMove();
  }

  // ============================================================
  // AI MOVE
  // ============================================================

  Future<void> _aiMove() async {
    setState(() {
      aiThinking = true;
    });

    await Future.delayed(
      const Duration(
        milliseconds: 450,
      ),
    );

    if (!mounted || gameOver) {
      return;
    }

    final move = _findEasyAiMove();

    if (move == -1) {
      return;
    }

    setState(() {
      board[move] = 'O';
      aiThinking = false;
      playerTurn = true;
    });

    _checkGameResult('O');
  }

  // ============================================================
  // EASY / BEATABLE AI
  // ============================================================

  int _findEasyAiMove() {
    final emptyCells = <int>[];

    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        emptyCells.add(i);
      }
    }

    if (emptyCells.isEmpty) {
      return -1;
    }

    // ----------------------------------------------------------
    // Sometimes AI makes a random move.
    // ----------------------------------------------------------

    if (_random.nextDouble() < 0.45) {
      return emptyCells[
          _random.nextInt(
            emptyCells.length,
          )];
    }

    // ----------------------------------------------------------
    // Try to win.
    // ----------------------------------------------------------

    final winningMove =
        _findWinningMove('O');

    if (winningMove != -1) {
      return winningMove;
    }

    // ----------------------------------------------------------
    // Sometimes block the player.
    // ----------------------------------------------------------

    if (_random.nextDouble() < 0.65) {
      final blockingMove =
          _findWinningMove('X');

      if (blockingMove != -1) {
        return blockingMove;
      }
    }

    // ----------------------------------------------------------
    // Prefer center occasionally.
    // ----------------------------------------------------------

    if (board[4].isEmpty &&
        _random.nextDouble() < 0.6) {
      return 4;
    }

    // ----------------------------------------------------------
    // Otherwise random empty cell.
    // ----------------------------------------------------------

    return emptyCells[
        _random.nextInt(
          emptyCells.length,
        )];
  }

  // ============================================================
  // FIND WINNING MOVE
  // ============================================================

  int _findWinningMove(
    String symbol,
  ) {
    for (final line in winningLines) {
      final values = [
        board[line[0]],
        board[line[1]],
        board[line[2]],
      ];

      final symbolCount =
          values.where(
        (value) => value == symbol,
      ).length;

      final emptyCount =
          values.where(
        (value) => value.isEmpty,
      ).length;

      if (symbolCount == 2 &&
          emptyCount == 1) {
        for (final index in line) {
          if (board[index].isEmpty) {
            return index;
          }
        }
      }
    }

    return -1;
  }

  // ============================================================
  // CHECK GAME RESULT
  // ============================================================

  bool _checkGameResult(
    String symbol,
  ) {
    if (_hasWinner(symbol)) {
      setState(() {
        gameOver = true;

        if (symbol == 'X') {
          playerScore++;
        } else {
          aiScore++;
        }
      });

      // --------------------------------------------------------
      // AWARD GAME XP
      // --------------------------------------------------------

      _awardGameResultXp(
        symbol == 'X'
            ? _habitStore.ticTacToeWinReward
            : _habitStore.ticTacToeLossReward,
      );

      return true;
    }

    if (!board.contains('')) {
      setState(() {
        gameOver = true;
        drawScore++;
      });

      // --------------------------------------------------------
      // AWARD DRAW XP
      // --------------------------------------------------------

      _awardGameResultXp(
        _habitStore.ticTacToeDrawReward,
      );

      return true;
    }

    return false;
  }

  // ============================================================
  // AWARD GAME XP
  // ============================================================

  Future<void> _awardGameResultXp(
    int xp,
  ) async {
    // ----------------------------------------------------------
    // SEND XP TO CENTRAL HABIT STORE
    // ----------------------------------------------------------

    final awardedXp =
        await _habitStore.awardGameXp(
      xp,
    );

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // SHOW RESULT DIALOG
    // ----------------------------------------------------------

    if (playerScore > 0 &&
        aiScore + drawScore <
            playerScore) {
      // This condition is NOT used to determine the result.
      //
      // The actual result is handled below by the stored
      // game result state.
    }

    String title;
    String message;
    IconData icon;

    if (xp ==
        _habitStore.ticTacToeWinReward) {
      title = 'You Win! 🎉';
      message =
          'Amazing! You got three in a row.\n\n+$awardedXp XP earned!';
      icon = Icons.emoji_events_rounded;
    } else if (xp ==
        _habitStore.ticTacToeDrawReward) {
      title = 'It\'s a Draw! 🤝';
      message =
          'Nobody won this round.\n\n+$awardedXp XP earned!';
      icon = Icons.handshake_rounded;
    } else {
      title = 'AI Wins 🤖';
      message =
          'The AI got three in a row. Try again!';
      icon = Icons.smart_toy_rounded;
    }

    _showResultDialog(
      title,
      message,
      icon,
      awardedXp,
    );
  }

  // ============================================================
  // CHECK WINNER
  // ============================================================

  bool _hasWinner(
    String symbol,
  ) {
    for (final line in winningLines) {
      if (board[line[0]] == symbol &&
          board[line[1]] == symbol &&
          board[line[2]] == symbol) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // RESTART GAME
  // ============================================================

  void _newGame() {
    setState(() {
      board = List.filled(
        9,
        '',
      );

      playerTurn = true;
      gameOver = false;
      aiThinking = false;
    });
  }

  // ============================================================
  // RESET SCORE
  // ============================================================

  void _resetScore() {
    setState(() {
      playerScore = 0;
      aiScore = 0;
      drawScore = 0;
    });

    _newGame();
  }

  // ============================================================
  // RESULT DIALOG
  // ============================================================

  void _showResultDialog(
    String title,
    String message,
    IconData icon,
    int awardedXp,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(
              25,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _cardBackground,
                  _isDark
                      ? AppColors.darkSoftBlue
                      : AppColors.softBlue,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                26,
              ),
              border: Border.all(
                color: _primaryBlue.withValues(
                  alpha: 0.20,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryBlue.withValues(
                    alpha: _isDark ? 0.25 : 0.18,
                  ),
                  blurRadius: 30,
                  offset: const Offset(
                    0,
                    10,
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                // ==================================================
                // RESULT ICON
                // ==================================================

                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _brightBlue,
                        _primaryBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            _primaryBlue.withValues(
                          alpha: 0.25,
                        ),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 31,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  title,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 23,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                // ==================================================
                // MESSAGE
                // ==================================================

                Text(
                  message,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: _secondaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                // ==================================================
                // XP BADGE
                // ==================================================

                if (awardedXp > 0) ...[
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        colors: [
                          _xpOrange,
                          _isDark
                              ? AppColors.darkXpDark
                              : const Color(
                                  0xFFFFD76A,
                                ),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              _xpOrange.withValues(
                            alpha: 0.18,
                          ),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '+$awardedXp XP',
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(
                  height: 22,
                ),

                // ==================================================
                // PLAY AGAIN
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  child:
                      ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );

                      _newGame();
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          _primaryBlue,
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 13,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'Play Again',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(
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
        backgroundColor:
            Colors.transparent,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          backgroundColor:
              Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 20,

          leading:
              IconButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            icon: Icon(
              Icons
                  .arrow_back_ios_new_rounded,
              color: _primaryText,
              size: 20,
            ),
          ),

          title:
              Text(
            'Tic-Tac-Toe',
            style: TextStyle(
              color: _primaryText,
              fontSize: 23,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          actions: [
            IconButton(
              onPressed:
                  _resetScore,
              tooltip:
                  'Reset score',
              icon:
                  Icon(
                Icons
                    .refresh_rounded,
                color:
                    _primaryBlue,
                size: 24,
              ),
            ),

            const SizedBox(
              width: 8,
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: Stack(
          children: [
            // --------------------------------------------------
            // BLUE GLOW
            // --------------------------------------------------

            Positioned(
              top: -90,
              right: -120,
              child: _glow(
                size: 300,
                color: _brightBlue,
                opacity: _isDark ? 0.18 : 0.14,
              ),
            ),

            // --------------------------------------------------
            // VIOLET GLOW
            // --------------------------------------------------

            Positioned(
              bottom: -130,
              left: -120,
              child: _glow(
                size: 330,
                color: _purple,
                opacity: _isDark ? 0.14 : 0.10,
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
                30,
              ),
              child: Column(
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  Text(
                    'Your Turn',
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    aiThinking
                        ? '🤖 AI is thinking...'
                        : playerTurn
                            ? 'Place your X on the board'
                            : 'AI is making its move',
                    style:
                        TextStyle(
                      color:
                          _secondaryText,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  // ==================================================
                  // GAME XP INFO
                  // ==================================================

                  _buildXpInfoCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================================
                  // SCORE CARD
                  // ==================================================

                  _buildScoreCard(),

                  const SizedBox(
                    height: 25,
                  ),

                  // ==================================================
                  // GAME BOARD
                  // ==================================================

                  _buildGameBoard(),

                  const SizedBox(
                    height: 25,
                  ),

                  // ==================================================
                  // NEW GAME BUTTON
                  // ==================================================

                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          _newGame,
                      icon:
                          const Icon(
                        Icons
                            .refresh_rounded,
                        size: 20,
                      ),
                      label:
                          const Text(
                        'New Game',
                      ),
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            _primaryBlue,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================================
                  // GAME TIP
                  // ==================================================

                  _buildTipCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // XP INFO CARD
  // ============================================================

  Widget _buildXpInfoCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDark
              ? [
                  AppColors.darkSoftViolet,
                  AppColors.darkSoftBlue,
                ]
              : [
                  const Color(0xFFFFF8E7),
                  const Color(0xFFFFF2C9),
                ],
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              _xpOrange.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(
              color:
                  _xpOrange,
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons.stars_rounded,
              color:
                  Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Earn XP while you play',
                  style:
                      TextStyle(
                    color:
                        _primaryText,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  'Win +30 XP  •  Draw +10 XP',
                  style:
                      TextStyle(
                    color:
                        _secondaryText,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
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
  // SCORE CARD
  // ============================================================

  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration:
          BoxDecoration(
        color:
            _cardBackground.withValues(
          alpha: _isDark ? 0.94 : 0.82,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color:
              _primaryBlue.withValues(
            alpha: 0.15,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                _primaryBlue.withValues(
              alpha: _isDark ? 0.14 : 0.08,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _scoreItem(
              icon:
                  Icons.person_rounded,
              label: 'You',
              score: playerScore,
              color:
                  _primaryBlue,
            ),
          ),

          Container(
            width: 1,
            height: 40,
            color:
                _primaryBlue.withValues(
              alpha: 0.10,
            ),
          ),

          Expanded(
            child: _scoreItem(
              icon:
                  Icons.handshake_rounded,
              label: 'Draws',
              score: drawScore,
              color:
                  _streakOrange,
            ),
          ),

          Container(
            width: 1,
            height: 40,
            color:
                _primaryBlue.withValues(
              alpha: 0.10,
            ),
          ),

          Expanded(
            child: _scoreItem(
              icon:
                  Icons.smart_toy_rounded,
              label: 'AI',
              score: aiScore,
              color:
                  _purple,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCORE ITEM
  // ============================================================

  Widget _scoreItem({
    required IconData icon,
    required String label,
    required int score,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 21,
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          '$score',
          style:
              TextStyle(
            color: _primaryText,
            fontSize: 20,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        Text(
          label,
          style:
              TextStyle(
            color:
                _secondaryText,
            fontSize: 11,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GAME BOARD
  // ============================================================

  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding:
            const EdgeInsets.all(
          13,
        ),
        decoration:
            BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: _isDark
                ? [
                    AppColors.darkCardBackground,
                    AppColors.darkSoftBlue,
                  ]
                : [
                    Colors.white,
                    AppColors.softBlue,
                  ],
          ),
          borderRadius:
              BorderRadius.circular(
            28,
          ),
          border: Border.all(
            color:
                _primaryBlue.withValues(
              alpha: 0.20,
            ),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _primaryBlue.withValues(
                alpha: _isDark ? 0.20 : 0.13,
              ),
              blurRadius: 30,
              offset:
                  const Offset(0, 10),
            ),
          ],
        ),
        child:
            GridView.builder(
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder:
              (context, index) {
            return _buildCell(
              index,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // GAME CELL
  // ============================================================

  Widget _buildCell(
    int index,
  ) {
    final value =
        board[index];

    final bool isX =
        value == 'X';

    return GestureDetector(
      onTap: () {
        _playerMove(index);
      },
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        decoration:
            BoxDecoration(
          gradient:
              value.isEmpty
                  ? LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: _isDark
                          ? [
                              AppColors.darkCardBackground,
                              AppColors.darkSoftBlue,
                            ]
                          : [
                              const Color(
                                0xFFF8FBFF,
                              ),
                              AppColors.softBlue,
                            ],
                    )
                  : LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: isX
                          ? [
                              _primaryBlue,
                              _brightBlue,
                            ]
                          : [
                              _gradientVioletDark,
                              _gradientVioletLight,
                            ],
                    ),
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: value.isEmpty
                ? _primaryBlue
                    .withValues(
                    alpha: 0.12,
                  )
                : Colors.transparent,
          ),
          boxShadow:
              value.isEmpty
                  ? null
                  : [
                      BoxShadow(
                        color: (isX
                                ? _primaryBlue
                                : _purple)
                            .withValues(
                          alpha: _isDark
                              ? 0.30
                              : 0.22,
                        ),
                        blurRadius:
                            15,
                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
        ),
        child:
            Center(
          child:
              AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds: 180,
            ),
            child:
                value.isEmpty
                    ? const SizedBox(
                        key:
                            ValueKey(
                          'empty',
                        ),
                      )
                    : Text(
                        value,
                        key:
                            ValueKey(
                          value,
                        ),
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              43,
                          fontWeight:
                              FontWeight
                                  .w900,
                          height: 1,
                          shadows: [
                            Shadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha:
                                    0.10,
                              ),
                              blurRadius:
                                  5,
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TIP CARD
  // ============================================================

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        color:
            _cardBackground.withValues(
          alpha: _isDark ? 0.88 : 0.72,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              _purple.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child:
          Row(
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color:
                _xpOrange,
            size: 23,
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child:
                Text(
              'Tip: Try taking the center or corners early in the game.',
              style:
                  TextStyle(
                color:
                    _secondaryText,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
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
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
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