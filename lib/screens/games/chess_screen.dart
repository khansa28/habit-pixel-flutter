
import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});

  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
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

  Color get _background =>
      _isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  // ============================================================
  // CHESS BOARD COLORS
  // ============================================================

  Color get _lightSquare =>
      _isDark
          ? const Color(0xFF18344D)
          : const Color(0xFFEAF4FF);

  Color get _darkSquare =>
      _isDark
          ? const Color(0xFF35658F)
          : const Color(0xFF6E9FD0);

  Color get _boardTop =>
      _isDark
          ? const Color(0xFF06121F)
          : const Color(0xFF173B65);

  Color get _boardBottom =>
      _isDark
          ? const Color(0xFF0A2035)
          : const Color(0xFF0B2747);

  Color get _blackPiece =>
      _isDark
          ? const Color(0xFFE2EAF2)
          : const Color(0xFF182A3A);

  // ============================================================
  // BOARD
  // ============================================================

  late List<List<String>> board;

  int? selectedRow;
  int? selectedCol;

  List<_Move> legalMovesForSelected = [];

  bool whiteTurn = true;
  bool gameOver = false;

  String statusText = 'Your turn';

  int whiteScore = 0;
  int blackScore = 0;

  final Random random = Random();

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _themeChanged,
    );

    _newGame();
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
  // NEW GAME
  // ============================================================

  void _newGame() {
    board = [
      [
        'r',
        'n',
        'b',
        'q',
        'k',
        'b',
        'n',
        'r',
      ],
      [
        'p',
        'p',
        'p',
        'p',
        'p',
        'p',
        'p',
        'p',
      ],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      [
        'P',
        'P',
        'P',
        'P',
        'P',
        'P',
        'P',
        'P',
      ],
      [
        'R',
        'N',
        'B',
        'Q',
        'K',
        'B',
        'N',
        'R',
      ],
    ];

    selectedRow = null;
    selectedCol = null;
    legalMovesForSelected = [];

    whiteTurn = true;
    gameOver = false;
    statusText = 'Your turn';

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // PIECE HELPERS
  // ============================================================

  bool _isWhite(String piece) {
    return piece.isNotEmpty && piece == piece.toUpperCase();
  }

  bool _isBlack(String piece) {
    return piece.isNotEmpty && piece == piece.toLowerCase();
  }

  bool _isInside(int row, int col) {
    return row >= 0 &&
        row < 8 &&
        col >= 0 &&
        col < 8;
  }

  // ============================================================
  // PIECE SYMBOLS
  // ============================================================

  String _pieceSymbol(String piece) {
    switch (piece) {
      case 'K':
        return '♔';
      case 'Q':
        return '♕';
      case 'R':
        return '♖';
      case 'B':
        return '♗';
      case 'N':
        return '♘';
      case 'P':
        return '♙';

      case 'k':
        return '♚';
      case 'q':
        return '♛';
      case 'r':
        return '♜';
      case 'b':
        return '♝';
      case 'n':
        return '♞';
      case 'p':
        return '♟';

      default:
        return '';
    }
  }

  // ============================================================
  // TAP SQUARE
  // ============================================================

  void _onSquareTapped(int row, int col) {
    if (gameOver || !whiteTurn) {
      return;
    }

    final piece = board[row][col];

    // ----------------------------------------------------------
    // SELECT WHITE PIECE
    // ----------------------------------------------------------

    if (selectedRow == null) {
      if (_isWhite(piece)) {
        _selectPiece(row, col);
      }

      return;
    }

    // ----------------------------------------------------------
    // SELECT ANOTHER WHITE PIECE
    // ----------------------------------------------------------

    if (_isWhite(piece)) {
      _selectPiece(row, col);
      return;
    }

    // ----------------------------------------------------------
    // TRY MOVE
    // ----------------------------------------------------------

    final move = legalMovesForSelected.where(
      (m) => m.toRow == row && m.toCol == col,
    );

    if (move.isEmpty) {
      return;
    }

    _makePlayerMove(move.first);
  }

  // ============================================================
  // SELECT PIECE
  // ============================================================

  void _selectPiece(int row, int col) {
    selectedRow = row;
    selectedCol = col;

    legalMovesForSelected = _legalMoves(
      board,
      row,
      col,
    );

    setState(() {});
  }

  // ============================================================
  // PLAYER MOVE
  // ============================================================

  void _makePlayerMove(_Move move) {
    final captured = board[move.toRow][move.toCol];

    _applyMove(board, move);

    selectedRow = null;
    selectedCol = null;
    legalMovesForSelected = [];

    if (captured.isNotEmpty) {
      whiteScore++;
    }

    whiteTurn = false;

    if (_isCheckmate(board, false)) {
      gameOver = true;
      statusText = 'You won! 🎉';
      whiteScore += 3;

      setState(() {});
      return;
    }

    if (_isStalemate(board, false)) {
      gameOver = true;
      statusText = 'Draw 🤝';

      setState(() {});
      return;
    }

    statusText = 'AI is thinking...';

    setState(() {});

    Future.delayed(
      const Duration(milliseconds: 650),
      _makeAiMove,
    );
  }

  // ============================================================
  // AI MOVE
  // ============================================================

  void _makeAiMove() {
    if (!mounted || gameOver) {
      return;
    }

    final moves = _allLegalMoves(
      board,
      false,
    );

    if (moves.isEmpty) {
      return;
    }

    _Move bestMove = moves.first;
    int bestScore = -1000000;

    // ----------------------------------------------------------
    // LIGHTWEIGHT AI
    // ----------------------------------------------------------
    //
    // The AI evaluates captures and basic position value.
    // This keeps the game responsive on a phone.

    for (final move in moves) {
      final copy = _copyBoard(board);

      final captured = copy[move.toRow][move.toCol];

      _applyMove(copy, move);

      int score = _evaluateBoard(copy);

      if (captured.isNotEmpty) {
        score += _pieceValue(captured) * 3;
      }

      // Prefer moves that give check.
      if (_isKingInCheck(copy, true)) {
        score += 60;
      }

      score += random.nextInt(8);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    final captured =
        board[bestMove.toRow][bestMove.toCol];

    _applyMove(board, bestMove);

    if (captured.isNotEmpty) {
      blackScore++;
    }

    whiteTurn = true;

    if (_isCheckmate(board, true)) {
      gameOver = true;
      statusText = 'AI wins! ♟️';
      blackScore += 3;
    } else if (_isStalemate(board, true)) {
      gameOver = true;
      statusText = 'Draw 🤝';
    } else if (_isKingInCheck(board, true)) {
      statusText = 'Check! Your move';
    } else {
      statusText = 'Your turn';
    }

    setState(() {});
  }

  // ============================================================
  // LEGAL MOVES
  // ============================================================

  List<_Move> _legalMoves(
    List<List<String>> currentBoard,
    int row,
    int col,
  ) {
    final piece = currentBoard[row][col];

    if (piece.isEmpty) {
      return [];
    }

    final pseudoMoves = _pseudoMoves(
      currentBoard,
      row,
      col,
    );

    final legal = <_Move>[];

    for (final move in pseudoMoves) {
      final copy = _copyBoard(currentBoard);

      _applyMove(copy, move);

      final movingWhite = _isWhite(piece);

      if (!_isKingInCheck(
        copy,
        movingWhite,
      )) {
        legal.add(move);
      }
    }

    return legal;
  }

  // ============================================================
  // ALL LEGAL MOVES
  // ============================================================

  List<_Move> _allLegalMoves(
    List<List<String>> currentBoard,
    bool white,
  ) {
    final moves = <_Move>[];

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = currentBoard[row][col];

        if (piece.isEmpty) {
          continue;
        }

        if (_isWhite(piece) != white) {
          continue;
        }

        moves.addAll(
          _legalMoves(
            currentBoard,
            row,
            col,
          ),
        );
      }
    }

    return moves;
  }

  // ============================================================
  // PSEUDO MOVES
  // ============================================================

  List<_Move> _pseudoMoves(
    List<List<String>> currentBoard,
    int row,
    int col,
  ) {
    final piece = currentBoard[row][col];

    if (piece.isEmpty) {
      return [];
    }

    final moves = <_Move>[];

    final type = piece.toLowerCase();
    final white = _isWhite(piece);

    // ==========================================================
    // PAWN
    // ==========================================================

    if (type == 'p') {
      final direction = white ? -1 : 1;
      final startRow = white ? 6 : 1;

      final oneRow = row + direction;

      if (_isInside(oneRow, col) &&
          currentBoard[oneRow][col].isEmpty) {
        moves.add(
          _Move(
            row,
            col,
            oneRow,
            col,
          ),
        );

        final twoRow = row + direction * 2;

        if (row == startRow &&
            _isInside(twoRow, col) &&
            currentBoard[twoRow][col].isEmpty) {
          moves.add(
            _Move(
              row,
              col,
              twoRow,
              col,
            ),
          );
        }
      }

      for (final dc in [-1, 1]) {
        final newRow = row + direction;
        final newCol = col + dc;

        if (!_isInside(newRow, newCol)) {
          continue;
        }

        final target =
            currentBoard[newRow][newCol];

        if (target.isNotEmpty &&
            _isWhite(target) != white) {
          moves.add(
            _Move(
              row,
              col,
              newRow,
              newCol,
            ),
          );
        }
      }

      return moves;
    }

    // ==========================================================
    // KNIGHT
    // ==========================================================

    if (type == 'n') {
      const offsets = [
        [-2, -1],
        [-2, 1],
        [-1, -2],
        [-1, 2],
        [1, -2],
        [1, 2],
        [2, -1],
        [2, 1],
      ];

      for (final offset in offsets) {
        final newRow = row + offset[0];
        final newCol = col + offset[1];

        _addIfValid(
          moves,
          currentBoard,
          row,
          col,
          newRow,
          newCol,
          white,
        );
      }

      return moves;
    }

    // ==========================================================
    // KING
    // ==========================================================

    if (type == 'k') {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) {
            continue;
          }

          _addIfValid(
            moves,
            currentBoard,
            row,
            col,
            row + dr,
            col + dc,
            white,
          );
        }
      }

      return moves;
    }

    // ==========================================================
    // ROOK / BISHOP / QUEEN
    // ==========================================================

    if (type == 'r' || type == 'q') {
      _addSlidingMoves(
        moves,
        currentBoard,
        row,
        col,
        white,
        const [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
        ],
      );
    }

    if (type == 'b' || type == 'q') {
      _addSlidingMoves(
        moves,
        currentBoard,
        row,
        col,
        white,
        const [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ],
      );
    }

    return moves;
  }

  // ============================================================
  // ADD VALID MOVE
  // ============================================================

  void _addIfValid(
    List<_Move> moves,
    List<List<String>> currentBoard,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
    bool white,
  ) {
    if (!_isInside(toRow, toCol)) {
      return;
    }

    final target = currentBoard[toRow][toCol];

    if (target.isEmpty ||
        _isWhite(target) != white) {
      moves.add(
        _Move(
          fromRow,
          fromCol,
          toRow,
          toCol,
        ),
      );
    }
  }

  // ============================================================
  // SLIDING MOVES
  // ============================================================

  void _addSlidingMoves(
    List<_Move> moves,
    List<List<String>> currentBoard,
    int row,
    int col,
    bool white,
    List<List<int>> directions,
  ) {
    for (final direction in directions) {
      int newRow = row + direction[0];
      int newCol = col + direction[1];

      while (_isInside(newRow, newCol)) {
        final target =
            currentBoard[newRow][newCol];

        if (target.isEmpty) {
          moves.add(
            _Move(
              row,
              col,
              newRow,
              newCol,
            ),
          );
        } else {
          if (_isWhite(target) != white) {
            moves.add(
              _Move(
                row,
                col,
                newRow,
                newCol,
              ),
            );
          }

          break;
        }

        newRow += direction[0];
        newCol += direction[1];
      }
    }
  }

  // ============================================================
  // APPLY MOVE
  // ============================================================

  void _applyMove(
    List<List<String>> currentBoard,
    _Move move,
  ) {
    String piece =
        currentBoard[move.fromRow][move.fromCol];

    currentBoard[move.fromRow][move.fromCol] = '';

    // ----------------------------------------------------------
    // PROMOTION
    // ----------------------------------------------------------

    if (piece == 'P' && move.toRow == 0) {
      piece = 'Q';
    }

    if (piece == 'p' && move.toRow == 7) {
      piece = 'q';
    }

    currentBoard[move.toRow][move.toCol] = piece;
  }

  // ============================================================
  // COPY BOARD
  // ============================================================

  List<List<String>> _copyBoard(
    List<List<String>> source,
  ) {
    return source
        .map((row) => List<String>.from(row))
        .toList();
  }

  // ============================================================
  // FIND KING
  // ============================================================

  Point<int>? _findKing(
    List<List<String>> currentBoard,
    bool white,
  ) {
    final king = white ? 'K' : 'k';

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (currentBoard[row][col] == king) {
          return Point(row, col);
        }
      }
    }

    return null;
  }

  // ============================================================
  // CHECK
  // ============================================================

  bool _isKingInCheck(
    List<List<String>> currentBoard,
    bool white,
  ) {
    final king = _findKing(
      currentBoard,
      white,
    );

    if (king == null) {
      return true;
    }

    final enemyMoves = _allPseudoMovesForSide(
      currentBoard,
      !white,
    );

    return enemyMoves.any(
      (move) =>
          move.toRow == king.x &&
          move.toCol == king.y,
    );
  }

  // ============================================================
  // PSEUDO MOVES FOR SIDE
  // ============================================================

  List<_Move> _allPseudoMovesForSide(
    List<List<String>> currentBoard,
    bool white,
  ) {
    final moves = <_Move>[];

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = currentBoard[row][col];

        if (piece.isEmpty) {
          continue;
        }

        if (_isWhite(piece) != white) {
          continue;
        }

        moves.addAll(
          _pseudoMoves(
            currentBoard,
            row,
            col,
          ),
        );
      }
    }

    return moves;
  }

  // ============================================================
  // CHECKMATE
  // ============================================================

  bool _isCheckmate(
    List<List<String>> currentBoard,
    bool white,
  ) {
    if (!_isKingInCheck(
      currentBoard,
      white,
    )) {
      return false;
    }

    return _allLegalMoves(
      currentBoard,
      white,
    ).isEmpty;
  }

  // ============================================================
  // STALEMATE
  // ============================================================

  bool _isStalemate(
    List<List<String>> currentBoard,
    bool white,
  ) {
    if (_isKingInCheck(
      currentBoard,
      white,
    )) {
      return false;
    }

    return _allLegalMoves(
      currentBoard,
      white,
    ).isEmpty;
  }

  // ============================================================
  // AI EVALUATION
  // ============================================================

  int _evaluateBoard(
    List<List<String>> currentBoard,
  ) {
    int score = 0;

    for (final row in currentBoard) {
      for (final piece in row) {
        if (piece.isEmpty) {
          continue;
        }

        final value = _pieceValue(piece);

        if (_isBlack(piece)) {
          score += value;
        } else {
          score -= value;
        }
      }
    }

    return score;
  }

  // ============================================================
  // PIECE VALUE
  // ============================================================

  int _pieceValue(String piece) {
    switch (piece.toLowerCase()) {
      case 'p':
        return 100;
      case 'n':
        return 320;
      case 'b':
        return 330;
      case 'r':
        return 500;
      case 'q':
        return 900;
      case 'k':
        return 20000;
      default:
        return 0;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _primaryText,

        title: Text(
          'Chess',
          style: TextStyle(
            color: _primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'New Game',
            onPressed: _newGame,
            icon: Icon(
              Icons.refresh_rounded,
              color: _primaryBlue,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            5,
            16,
            20,
          ),
          child: Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You vs AI ♟️',
                          style: TextStyle(
                            color: _primaryText,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: _secondaryText,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _scoreChip(
                    Icons.person_rounded,
                    '$whiteScore',
                    _primaryBlue,
                  ),

                  const SizedBox(width: 8),

                  _scoreChip(
                    Icons.smart_toy_rounded,
                    '$blackScore',
                    _gradientVioletDark,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==================================================
              // AI LABEL
              // ==================================================

              Align(
                alignment:
                    Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _primaryBlue.withValues(
                        alpha:
                            _isDark
                                ? 0.28
                                : 0.12,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.smart_toy_rounded,
                        size: 15,
                        color:
                            _gradientVioletDark,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'AI plays Black',
                        style: TextStyle(
                          color: _primaryText,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // CHESS BOARD
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      _boardTop,
                      _boardBottom,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(22),
                  border: Border.all(
                    color:
                        _brightBlue.withValues(
                      alpha:
                          _isDark
                              ? 0.45
                              : 0.35,
                    ),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isDark
                                  ? AppColors
                                      .darkBlueGlow
                                  : AppColors
                                      .blueGlow)
                              .withValues(
                        alpha:
                            _isDark
                                ? 0.24
                                : 0.18,
                      ),
                      blurRadius: 28,
                      offset:
                          const Offset(0, 10),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15),
                    child: GridView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: 64,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                      ),
                      itemBuilder:
                          (context, index) {
                        final row =
                            index ~/ 8;
                        final col =
                            index % 8;

                        final isLight =
                            (row + col) % 2 ==
                                0;

                        final isSelected =
                            selectedRow == row &&
                                selectedCol ==
                                    col;

                        final isLegalMove =
                            legalMovesForSelected
                                .any(
                          (move) =>
                              move.toRow ==
                                  row &&
                              move.toCol ==
                                  col,
                        );

                        return GestureDetector(
                          onTap: () =>
                              _onSquareTapped(
                            row,
                            col,
                          ),
                          child:
                              AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds:
                                  120,
                            ),
                            decoration:
                                BoxDecoration(
                              color: isSelected
                                  ? _brightBlue
                                  : isLight
                                      ? _lightSquare
                                      : _darkSquare,
                            ),
                            child: Stack(
                              alignment:
                                  Alignment.center,
                              children: [
                                // ------------------------------------------------
                                // POSSIBLE MOVE
                                // ------------------------------------------------

                                if (isLegalMove)
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape
                                              .circle,
                                      color:
                                          _primaryBlue
                                              .withValues(
                                        alpha: 0.65,
                                      ),
                                    ),
                                  ),

                                // ------------------------------------------------
                                // PIECE
                                // ------------------------------------------------

                                if (board[row][col]
                                    .isNotEmpty)
                                  FittedBox(
                                    fit: BoxFit
                                        .contain,
                                    child: Text(
                                      _pieceSymbol(
                                        board[row][col],
                                      ),
                                      style:
                                          TextStyle(
                                        fontSize:
                                            38,
                                        height: 1,
                                        color:
                                            _isWhite(
                                          board[row]
                                              [col],
                                        )
                                                ? Colors
                                                    .white
                                                : _blackPiece,
                                        shadows: [
                                          Shadow(
                                            color: Colors
                                                .black
                                                .withValues(
                                              alpha:
                                                  0.35,
                                            ),
                                            offset:
                                                const Offset(
                                              1,
                                              2,
                                            ),
                                            blurRadius:
                                                2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // ------------------------------------------------
                                // CAPTURE INDICATOR
                                // ------------------------------------------------

                                if (isLegalMove &&
                                    board[row][col]
                                        .isNotEmpty)
                                  Container(
                                    decoration:
                                        BoxDecoration(
                                      border:
                                          Border.all(
                                        color:
                                            Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // INSTRUCTIONS
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardBackground,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color:
                        _primaryBlue.withValues(
                      alpha:
                          _isDark
                              ? 0.25
                              : 0.12,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _primaryBlue.withValues(
                        alpha:
                            _isDark
                                ? 0.12
                                : 0.06,
                      ),
                      blurRadius: 15,
                      offset:
                          const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          colors: [
                            _brightBlue,
                            _primaryBlue,
                          ],
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(13),
                      ),
                      child: const Icon(
                        Icons
                            .touch_app_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'How to play',
                            style: TextStyle(
                              color:
                                  _primaryText,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Tap a piece, then tap a highlighted square to move.',
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
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // NEW GAME BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                    ElevatedButton.icon(
                  onPressed: _newGame,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: const Text(
                    'New Game',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w800,
                    ),
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

              const SizedBox(height: 8),

              // ==================================================
              // GAME RESULT
              // ==================================================

              if (gameOver)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      colors: [
                        _isDark
                            ? AppColors
                                .darkSoftBlue
                            : AppColors
                                .softBlue,
                        _cardBackground,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                    border: Border.all(
                      color:
                          _primaryBlue
                              .withValues(
                        alpha:
                            _isDark
                                ? 0.28
                                : 0.15,
                      ),
                    ),
                  ),
                  child: Text(
                    statusText,
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SCORE CHIP
  // ============================================================

  Widget _scoreChip(
    IconData icon,
    String score,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: color.withValues(
            alpha:
                _isDark
                    ? 0.30
                    : 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            score,
            style: TextStyle(
              color: _primaryText,
              fontSize: 12,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// MOVE MODEL
// ================================================================

class _Move {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;

  const _Move(
    this.fromRow,
    this.fromCol,
    this.toRow,
    this.toCol,
  );
}
