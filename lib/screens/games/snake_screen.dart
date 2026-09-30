import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';

class SnakeScreen extends StatefulWidget {
  const SnakeScreen({super.key});

  @override
  State<SnakeScreen> createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  static const int columns = 18;
  static const int rows = 24;

  final Random random = Random();

  Timer? gameTimer;

  List<Point<int>> snake = [];

  Point<int> food = const Point(8, 8);

  String direction = 'right';
  String nextDirection = 'right';

  int score = 0;

  bool isPlaying = false;
  bool gameOver = false;

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

  Color get _brightBlue =>
      _isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get _deepBlue =>
      _isDark
          ? AppColors.darkDeepBlue
          : AppColors.deepBlue;

  Color get _primaryText =>
      _isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get _secondaryText =>
      _isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

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

  Color get _blueGlow =>
      _isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  Color get _success =>
      _isDark
          ? AppColors.darkSuccess
          : AppColors.success;

  Color get _successLight =>
      _isDark
          ? AppColors.darkSuccessLight
          : AppColors.successLight;

  // ============================================================
  // THEME LISTENER
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _themeChanged,
    );

    _resetGame();
  }

  void _themeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();

    ThemeController.instance.removeListener(
      _themeChanged,
    );

    super.dispose();
  }

  // ============================================================
  // RESET GAME
  // ============================================================

  void _resetGame() {
    gameTimer?.cancel();

    snake = [
      const Point(9, 12),
      const Point(8, 12),
      const Point(7, 12),
      const Point(6, 12),
    ];

    direction = 'right';
    nextDirection = 'right';

    score = 0;
    isPlaying = false;
    gameOver = false;

    _generateFood();

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // START GAME
  // ============================================================

  void _startGame() {
    if (isPlaying) {
      return;
    }

    if (gameOver) {
      _resetGame();
    }

    setState(() {
      isPlaying = true;
      gameOver = false;
    });

    gameTimer = Timer.periodic(
      const Duration(milliseconds: 150),
      (_) => _moveSnake(),
    );
  }

  // ============================================================
  // MOVE SNAKE
  // ============================================================

  void _moveSnake() {
    if (!mounted || !isPlaying) {
      return;
    }

    direction = nextDirection;

    final head = snake.first;

    int newX = head.x;
    int newY = head.y;

    if (direction == 'up') {
      newY--;
    } else if (direction == 'down') {
      newY++;
    } else if (direction == 'left') {
      newX--;
    } else if (direction == 'right') {
      newX++;
    }

    // ==========================================================
    // WRAP AROUND THE SCREEN
    // ==========================================================

    if (newX < 0) {
      newX = columns - 1;
    }

    if (newX >= columns) {
      newX = 0;
    }

    if (newY < 0) {
      newY = rows - 1;
    }

    if (newY >= rows) {
      newY = 0;
    }

    final newHead = Point<int>(newX, newY);

    // ==========================================================
    // SELF COLLISION
    // ==========================================================

    if (snake.contains(newHead)) {
      _endGame();
      return;
    }

    final newSnake = <Point<int>>[
      newHead,
      ...snake,
    ];

    // ==========================================================
    // FOOD
    // ==========================================================

    if (newHead == food) {
      score++;
      _generateFood();
    } else {
      newSnake.removeLast();
    }

    setState(() {
      snake = newSnake;
    });
  }

  // ============================================================
  // GENERATE FOOD
  // ============================================================

  void _generateFood() {
    Point<int> newFood;

    do {
      newFood = Point<int>(
        random.nextInt(columns),
        random.nextInt(rows),
      );
    } while (snake.contains(newFood));

    food = newFood;
  }

  // ============================================================
  // END GAME
  // ============================================================

  void _endGame() {
    gameTimer?.cancel();

    setState(() {
      isPlaying = false;
      gameOver = true;
    });
  }

  // ============================================================
  // CHANGE DIRECTION
  // ============================================================

  void _changeDirection(String newDirection) {
    if (!isPlaying) {
      return;
    }

    if (newDirection == 'up' && direction == 'down') {
      return;
    }

    if (newDirection == 'down' && direction == 'up') {
      return;
    }

    if (newDirection == 'left' && direction == 'right') {
      return;
    }

    if (newDirection == 'right' && direction == 'left') {
      return;
    }

    nextDirection = newDirection;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundBottom,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _primaryText,

        title: Text(
          'Snake',
          style: TextStyle(
            color: _primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 18,
              top: 8,
              bottom: 8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: _cardBackground,
              borderRadius:
                  BorderRadius.circular(15),
              border: Border.all(
                color: _primaryBlue.withValues(
                  alpha: 0.18,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryBlue.withValues(
                    alpha: _isDark ? 0.10 : 0.05,
                  ),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars_rounded,
                  color:
                      _isDark
                          ? AppColors.darkXpOrange
                          : AppColors.xpOrange,
                  size: 19,
                ),
                const SizedBox(width: 5),
                Text(
                  '$score',
                  style: TextStyle(
                    color: _primaryText,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 5),

              // ======================================================
              // HEADER
              // ======================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catch the apples! 🍎',
                            style: TextStyle(
                              color: _primaryText,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Wrap around the edges and keep growing.',
                            style: TextStyle(
                              color:
                                  _secondaryText,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SCORE
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            LinearGradient(
                          colors: [
                            _gradientBlueLight,
                            _gradientBlueDark,
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$score',
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ======================================================
              // GAME BOARD
              // ======================================================

              Expanded(
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: AspectRatio(
                      aspectRatio:
                          columns / rows,
                      child: Container(
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment.topLeft,
                            end:
                                Alignment.bottomRight,
                            colors: _isDark
                                ? [
                                    const Color(
                                      0xFF102E4A,
                                    ),
                                    const Color(
                                      0xFF081D32,
                                    ),
                                  ]
                                : [
                                    const Color(
                                      0xFF173B65,
                                    ),
                                    const Color(
                                      0xFF0B2747,
                                    ),
                                  ],
                          ),
                          border:
                              Border.all(
                            color:
                                _brightBlue
                                    .withValues(
                              alpha: 0.35,
                            ),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  _primaryBlue
                                      .withValues(
                                alpha:
                                    _isDark
                                        ? 0.25
                                        : 0.18,
                              ),
                              blurRadius: 30,
                              offset:
                                  const Offset(
                                0,
                                10,
                              ),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            26,
                          ),
                          child: CustomPaint(
                            painter: _SnakePainter(
                              snake: snake,
                              food: food,
                              rows: rows,
                              columns: columns,
                              direction: direction,
                              isPlaying: isPlaying,

                              // Theme colors
                              snakeHeadColor:
                                  _brightBlue,
                              snakeBodyColor1:
                                  _isDark
                                      ? AppColors
                                          .darkSuccess
                                      : const Color(
                                          0xFF42D6C6,
                                        ),
                              snakeBodyColor2:
                                  _successLight,
                              eyeColor:
                                  _isDark
                                      ? AppColors
                                          .darkPrimaryText
                                      : Colors.white,
                              eyeBlackColor:
                                  _primaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ======================================================
              // GAME OVER
              // ======================================================

              if (gameOver)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 4,
                  ),
                  child: Text(
                    'Oops! Your snake bumped into itself 🐍',
                    style: TextStyle(
                      color:
                          _primaryText.withValues(
                        alpha: 0.85,
                      ),
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

              const SizedBox(height: 5),

              // ======================================================
              // CONTROLS
              // ======================================================

              _buildControls(),

              const SizedBox(height: 8),

              // ======================================================
              // START BUTTON
              // ======================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        gameOver
                            ? _resetGameAndStart
                            : _startGame,

                    icon: Icon(
                      gameOver
                          ? Icons.refresh_rounded
                          : Icons.play_arrow_rounded,
                    ),

                    label: Text(
                      gameOver
                          ? 'Play Again'
                          : isPlaying
                              ? 'Game Running'
                              : 'Start Game',
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          _primaryBlue,
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RESET + START
  // ============================================================

  void _resetGameAndStart() {
    _resetGame();
    _startGame();
  }

  // ============================================================
  // CONTROLS
  // ============================================================

  Widget _buildControls() {
    return Column(
      children: [
        _directionButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onPressed: () =>
              _changeDirection('up'),
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _directionButton(
              icon:
                  Icons.keyboard_arrow_left_rounded,
              onPressed: () =>
                  _changeDirection('left'),
            ),

            const SizedBox(width: 55),

            _directionButton(
              icon:
                  Icons.keyboard_arrow_right_rounded,
              onPressed: () =>
                  _changeDirection('right'),
            ),
          ],
        ),

        _directionButton(
          icon:
              Icons.keyboard_arrow_down_rounded,
          onPressed: () =>
              _changeDirection('down'),
        ),
      ],
    );
  }

  // ============================================================
  // DIRECTION BUTTON
  // ============================================================

  Widget _directionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color:
              _primaryBlue.withValues(
            alpha: 0.14,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                _primaryBlue.withValues(
              alpha: _isDark ? 0.12 : 0.08,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(13),
          onTap: onPressed,
          child: Icon(
            icon,
            color: _primaryBlue,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SNAKE PAINTER
// ================================================================

class _SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;

  final int rows;
  final int columns;

  final String direction;
  final bool isPlaying;

  // Theme colors
  final Color snakeHeadColor;
  final Color snakeBodyColor1;
  final Color snakeBodyColor2;
  final Color eyeColor;
  final Color eyeBlackColor;

  _SnakePainter({
    required this.snake,
    required this.food,
    required this.rows,
    required this.columns,
    required this.direction,
    required this.isPlaying,
    required this.snakeHeadColor,
    required this.snakeBodyColor1,
    required this.snakeBodyColor2,
    required this.eyeColor,
    required this.eyeBlackColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double cellWidth =
        size.width / columns;

    final double cellHeight =
        size.height / rows;

    // ==========================================================
    // SOFT GRID
    // ==========================================================

    final gridPaint = Paint()
      ..color =
          Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 1;

    for (int x = 1; x < columns; x++) {
      final dx = x * cellWidth;

      canvas.drawLine(
        Offset(dx, 0),
        Offset(dx, size.height),
        gridPaint,
      );
    }

    for (int y = 1; y < rows; y++) {
      final dy = y * cellHeight;

      canvas.drawLine(
        Offset(0, dy),
        Offset(size.width, dy),
        gridPaint,
      );
    }

    // ==========================================================
    // FOOD
    // ==========================================================

    _drawFood(
      canvas,
      food,
      cellWidth,
      cellHeight,
    );

    // ==========================================================
    // SNAKE
    // ==========================================================

    if (snake.isEmpty) {
      return;
    }

    _drawSnakeBody(
      canvas,
      cellWidth,
      cellHeight,
      size,
    );

    _drawSnakeHead(
      canvas,
      snake.first,
      cellWidth,
      cellHeight,
    );
  }

  // ============================================================
  // FOOD
  // ============================================================

  void _drawFood(
    Canvas canvas,
    Point<int> position,
    double cellWidth,
    double cellHeight,
  ) {
    final center = Offset(
      position.x * cellWidth +
          cellWidth / 2,
      position.y * cellHeight +
          cellHeight / 2,
    );

    // Glow
    final glowPaint = Paint()
      ..color =
          const Color(0xFFFF6B6B)
              .withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawCircle(
      center,
      cellWidth * 0.38,
      glowPaint,
    );

    // Apple
    final applePaint = Paint()
      ..color = const Color(0xFFFF5C67);

    canvas.drawCircle(
      Offset(
        center.dx - 3,
        center.dy + 2,
      ),
      cellWidth * 0.25,
      applePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + 3,
        center.dy + 2,
      ),
      cellWidth * 0.25,
      applePaint,
    );

    // Apple highlight
    final highlightPaint = Paint()
      ..color =
          Colors.white.withValues(alpha: 0.7);

    canvas.drawCircle(
      Offset(
        center.dx - 4,
        center.dy - 2,
      ),
      cellWidth * 0.06,
      highlightPaint,
    );

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF704214)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(
        center.dx,
        center.dy - cellWidth * 0.18,
      ),
      Offset(
        center.dx + 2,
        center.dy - cellWidth * 0.32,
      ),
      stemPaint,
    );

    // Leaf
    final leafPaint = Paint()
      ..color = const Color(0xFF4CD97B);

    final leafPath = Path();

    leafPath.moveTo(
      center.dx + 2,
      center.dy - cellWidth * 0.25,
    );

    leafPath.quadraticBezierTo(
      center.dx + cellWidth * 0.25,
      center.dy - cellWidth * 0.38,
      center.dx + cellWidth * 0.28,
      center.dy - cellWidth * 0.15,
    );

    leafPath.quadraticBezierTo(
      center.dx + cellWidth * 0.10,
      center.dy - cellWidth * 0.10,
      center.dx + 2,
      center.dy - cellWidth * 0.25,
    );

    canvas.drawPath(
      leafPath,
      leafPaint,
    );
  }

  // ============================================================
  // SNAKE BODY
  // ============================================================

  void _drawSnakeBody(
    Canvas canvas,
    double cellWidth,
    double cellHeight,
    Size size,
  ) {
    for (int i = snake.length - 1; i >= 1; i--) {
      final segment = snake[i];

      final center = Offset(
        segment.x * cellWidth +
            cellWidth / 2,
        segment.y * cellHeight +
            cellHeight / 2,
      );

      final double radius =
          cellWidth * 0.38;

      final bodyPaint = Paint()
        ..color = i.isEven
            ? snakeBodyColor1
            : snakeBodyColor2;

      // ========================================================
      // BODY CIRCLE
      // ========================================================

      canvas.drawCircle(
        center,
        radius,
        bodyPaint,
      );

      // ========================================================
      // BODY CONNECTION
      // ========================================================

      if (i > 1) {
        final previous = snake[i - 1];

        final previousCenter = Offset(
          previous.x * cellWidth +
              cellWidth / 2,
          previous.y * cellHeight +
              cellHeight / 2,
        );

        final connectionPaint = Paint()
          ..color = bodyPaint.color
          ..strokeWidth = cellWidth * 0.58
          ..strokeCap = StrokeCap.round;

        // ======================================================
        // NORMAL HORIZONTAL CONNECTION
        // ======================================================

        final bool normalHorizontal =
            segment.y == previous.y &&
            (segment.x - previous.x).abs() == 1;

        // ======================================================
        // NORMAL VERTICAL CONNECTION
        // ======================================================

        final bool normalVertical =
            segment.x == previous.x &&
            (segment.y - previous.y).abs() == 1;

        if (normalHorizontal ||
            normalVertical) {
          canvas.drawLine(
            center,
            previousCenter,
            connectionPaint,
          );
        }

        // ======================================================
        // HORIZONTAL WRAP
        //
        // Example:
        //
        // segment = column 0
        // previous = column 17
        //
        // They are actually adjacent because the board wraps.
        // ======================================================

        else if (segment.y == previous.y &&
            (segment.x - previous.x).abs() ==
                columns - 1) {
          // ----------------------------------------------------
          // LEFT EDGE -> RIGHT EDGE
          // ----------------------------------------------------

          if (segment.x == 0 &&
              previous.x == columns - 1) {
            canvas.drawLine(
              center,
              Offset(
                0,
                center.dy,
              ),
              connectionPaint,
            );

            canvas.drawLine(
              Offset(
                size.width,
                previousCenter.dy,
              ),
              previousCenter,
              connectionPaint,
            );
          }

          // ----------------------------------------------------
          // RIGHT EDGE -> LEFT EDGE
          // ----------------------------------------------------

          else if (segment.x == columns - 1 &&
              previous.x == 0) {
            canvas.drawLine(
              center,
              Offset(
                size.width,
                center.dy,
              ),
              connectionPaint,
            );

            canvas.drawLine(
              Offset(
                0,
                previousCenter.dy,
              ),
              previousCenter,
              connectionPaint,
            );
          }
        }

        // ======================================================
        // VERTICAL WRAP
        //
        // Example:
        //
        // segment = row 0
        // previous = row 23
        //
        // They are actually adjacent because the board wraps.
        // ======================================================

        else if (segment.x == previous.x &&
            (segment.y - previous.y).abs() ==
                rows - 1) {
          // ----------------------------------------------------
          // TOP EDGE -> BOTTOM EDGE
          // ----------------------------------------------------

          if (segment.y == 0 &&
              previous.y == rows - 1) {
            canvas.drawLine(
              center,
              Offset(
                center.dx,
                0,
              ),
              connectionPaint,
            );

            canvas.drawLine(
              Offset(
                previousCenter.dx,
                size.height,
              ),
              previousCenter,
              connectionPaint,
            );
          }

          // ----------------------------------------------------
          // BOTTOM EDGE -> TOP EDGE
          // ----------------------------------------------------

          else if (segment.y == rows - 1 &&
              previous.y == 0) {
            canvas.drawLine(
              center,
              Offset(
                center.dx,
                size.height,
              ),
              connectionPaint,
            );

            canvas.drawLine(
              Offset(
                previousCenter.dx,
                0,
              ),
              previousCenter,
              connectionPaint,
            );
          }
        }
      }
    }
  }

  // ============================================================
  // SNAKE HEAD
  // ============================================================

  void _drawSnakeHead(
    Canvas canvas,
    Point<int> position,
    double cellWidth,
    double cellHeight,
  ) {
    final center = Offset(
      position.x * cellWidth +
          cellWidth / 2,
      position.y * cellHeight +
          cellHeight / 2,
    );

    final headPaint = Paint()
      ..color = snakeHeadColor;

    // ==========================================================
    // HEAD
    // ==========================================================

    canvas.drawCircle(
      center,
      cellWidth * 0.43,
      headPaint,
    );

    // ==========================================================
    // EYES
    // ==========================================================

    final eyeWhitePaint = Paint()
      ..color = eyeColor;

    final eyeBlackPaint = Paint()
      ..color = eyeBlackColor;

    Offset eye1;
    Offset eye2;

    if (direction == 'up') {
      eye1 = Offset(
        center.dx - cellWidth * 0.16,
        center.dy - cellHeight * 0.17,
      );

      eye2 = Offset(
        center.dx + cellWidth * 0.16,
        center.dy - cellHeight * 0.17,
      );
    } else if (direction == 'down') {
      eye1 = Offset(
        center.dx - cellWidth * 0.16,
        center.dy + cellHeight * 0.17,
      );

      eye2 = Offset(
        center.dx + cellWidth * 0.16,
        center.dy + cellHeight * 0.17,
      );
    } else if (direction == 'left') {
      eye1 = Offset(
        center.dx - cellWidth * 0.17,
        center.dy - cellHeight * 0.16,
      );

      eye2 = Offset(
        center.dx - cellWidth * 0.17,
        center.dy + cellHeight * 0.16,
      );
    } else {
      eye1 = Offset(
        center.dx + cellWidth * 0.17,
        center.dy - cellHeight * 0.16,
      );

      eye2 = Offset(
        center.dx + cellWidth * 0.17,
        center.dy + cellHeight * 0.16,
      );
    }

    canvas.drawCircle(
      eye1,
      cellWidth * 0.11,
      eyeWhitePaint,
    );

    canvas.drawCircle(
      eye2,
      cellWidth * 0.11,
      eyeWhitePaint,
    );

    // Pupils
    canvas.drawCircle(
      eye1,
      cellWidth * 0.055,
      eyeBlackPaint,
    );

    canvas.drawCircle(
      eye2,
      cellWidth * 0.055,
      eyeBlackPaint,
    );

    // ==========================================================
    // LITTLE SMILE
    // ==========================================================

    final smilePaint = Paint()
      ..color = eyeBlackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();

    if (direction == 'right') {
      smilePath.moveTo(
        center.dx + cellWidth * 0.17,
        center.dy + cellHeight * 0.15,
      );

      smilePath.quadraticBezierTo(
        center.dx + cellWidth * 0.28,
        center.dy + cellHeight * 0.24,
        center.dx + cellWidth * 0.34,
        center.dy + cellHeight * 0.13,
      );
    } else if (direction == 'left') {
      smilePath.moveTo(
        center.dx - cellWidth * 0.17,
        center.dy + cellHeight * 0.15,
      );

      smilePath.quadraticBezierTo(
        center.dx - cellWidth * 0.28,
        center.dy + cellHeight * 0.24,
        center.dx - cellWidth * 0.34,
        center.dy + cellHeight * 0.13,
      );
    } else if (direction == 'up') {
      smilePath.moveTo(
        center.dx + cellWidth * 0.14,
        center.dy - cellHeight * 0.17,
      );

      smilePath.quadraticBezierTo(
        center.dx + cellWidth * 0.23,
        center.dy - cellHeight * 0.28,
        center.dx + cellWidth * 0.12,
        center.dy - cellHeight * 0.34,
      );
    } else {
      smilePath.moveTo(
        center.dx + cellWidth * 0.14,
        center.dy + cellHeight * 0.17,
      );

      smilePath.quadraticBezierTo(
        center.dx + cellWidth * 0.23,
        center.dy + cellHeight * 0.28,
        center.dx + cellWidth * 0.12,
        center.dy + cellHeight * 0.34,
      );
    }

    canvas.drawPath(
      smilePath,
      smilePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _SnakePainter oldDelegate,
  ) {
    return oldDelegate.snake != snake ||
        oldDelegate.food != food ||
        oldDelegate.direction != direction ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.snakeHeadColor !=
            snakeHeadColor ||
        oldDelegate.snakeBodyColor1 !=
            snakeBodyColor1 ||
        oldDelegate.snakeBodyColor2 !=
            snakeBodyColor2 ||
        oldDelegate.eyeColor != eyeColor ||
        oldDelegate.eyeBlackColor !=
            eyeBlackColor;
  }
}