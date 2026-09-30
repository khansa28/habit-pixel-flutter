import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class AddHabitScreen extends StatefulWidget {
  // ============================================================
  // OPTIONAL HABIT
  // ============================================================
  //
  // null  -> Add mode
  // habit -> Edit mode
  //

  final Habit? habit;

  const AddHabitScreen({
    super.key,
    this.habit,
  });

  @override
  State<AddHabitScreen> createState() =>
      _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController subtitleController =
      TextEditingController();

  final TextEditingController goalController =
      TextEditingController();

  final TextEditingController timerController =
      TextEditingController(text: '25');

  String selectedUnit = 'sessions';

  // ============================================================
  // MODE
  // ============================================================

  bool get isEditing => widget.habit != null;

  // ============================================================
  // THEME COLORS
  // ============================================================

  bool get isDark =>
      ThemeController.instance.isDarkMode;

  Color get backgroundTop =>
      isDark
          ? AppColors.darkBackgroundTop
          : AppColors.backgroundTop;

  Color get backgroundMiddle =>
      isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  Color get backgroundBottom =>
      isDark
          ? AppColors.darkBackgroundBottom
          : AppColors.backgroundBottom;

  Color get primaryBlue =>
      isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get brightBlue =>
      isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get deepBlue =>
      isDark
          ? AppColors.darkDeepBlue
          : AppColors.deepBlue;

  Color get softBlue =>
      isDark
          ? AppColors.darkSoftBlue
          : AppColors.softBlue;

  Color get primaryText =>
      isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get secondaryText =>
      isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get mutedText =>
      isDark
          ? AppColors.darkMutedText
          : AppColors.mutedText;

  Color get cardBackground =>
      isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get cardBorder =>
      isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get progressBackground =>
      isDark
          ? AppColors.darkProgressBackground
          : AppColors.progressBackground;

  Color get gradientBlueLight =>
      isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get gradientBlueDark =>
      isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

  Color get xpOrange =>
      isDark
          ? AppColors.darkXpOrange
          : AppColors.xpOrange;

  Color get xpDark =>
      isDark
          ? AppColors.darkXpDark
          : AppColors.xpDark;

  Color get blueGlow =>
      isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    ThemeController.instance.addListener(
      _themeChanged,
    );

    // ----------------------------------------------------------
    // EDIT MODE
    // ----------------------------------------------------------

    if (widget.habit != null) {
      final habit = widget.habit!;

      titleController.text = habit.title;
      subtitleController.text = habit.subtitle;
      goalController.text = habit.goal.toString();

      selectedUnit = habit.unit;

      timerController.text =
          habit.timerMinutes.toString();
    }
  }

  // ============================================================
  // THEME CHANGE
  // ============================================================

  void _themeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    ThemeController.instance.removeListener(
      _themeChanged,
    );

    titleController.dispose();
    subtitleController.dispose();
    goalController.dispose();
    timerController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE / UPDATE HABIT
  // ============================================================

  void saveHabit() {
    final title = titleController.text.trim();
    final subtitle = subtitleController.text.trim();

    final goalText = goalController.text.trim();
    final timerText = timerController.text.trim();

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (title.isEmpty) {
      _showMessage('Please enter a habit name.');
      return;
    }

    if (goalText.isEmpty) {
      _showMessage('Please enter a goal.');
      return;
    }

    final goal = int.tryParse(goalText);

    if (goal == null || goal <= 0) {
      _showMessage(
        'Goal must be a valid number greater than 0.',
      );
      return;
    }

    // ----------------------------------------------------------
    // TIMER DURATION
    // ----------------------------------------------------------

    int timerMinutes;

    if (selectedUnit == 'minutes') {
      timerMinutes = goal;
    } else {
      if (timerText.isEmpty) {
        _showMessage(
          'Please enter timer duration.',
        );
        return;
      }

      final parsedTimer =
          int.tryParse(timerText);

      if (parsedTimer == null ||
          parsedTimer <= 0) {
        _showMessage(
          'Timer must be a valid number greater than 0.',
        );
        return;
      }

      timerMinutes = parsedTimer;
    }

    // ==========================================================
    // EDIT EXISTING HABIT
    // ==========================================================

    if (isEditing) {
      final habit = widget.habit!;

      // --------------------------------------------------------
      // UPDATE ONLY HABIT SETTINGS
      // --------------------------------------------------------
      //
      // We intentionally preserve:
      //
      // id
      // progress
      // streak
      // xp
      // completed
      // lastCompletedDate
      // lastActivityDate
      // lastXpDate
      //
      // --------------------------------------------------------

      habit.title = title;

      habit.subtitle = subtitle.isEmpty
          ? 'New habit'
          : subtitle;

      habit.goal = goal;
      habit.unit = selectedUnit;
      habit.timerMinutes = timerMinutes;

      // Recalculate completion based on the new goal.
      habit.completed =
          habit.progress >= habit.goal;

      Navigator.pop(
        context,
        habit,
      );

      return;
    }

    // ==========================================================
    // CREATE NEW HABIT
    // ==========================================================

    final habit = Habit(
      title: title,
      subtitle: subtitle.isEmpty
          ? 'New habit'
          : subtitle,
      goal: goal,
      progress: 0,
      unit: selectedUnit,
      timerMinutes: timerMinutes,
      streak: 0,
      completed: false,
    );

    // ----------------------------------------------------------
    // RETURN NEW HABIT TO HOME
    // ----------------------------------------------------------

    Navigator.pop(
      context,
      habit,
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      labelStyle: TextStyle(
        color: secondaryText,
        fontSize: 14,
      ),

      floatingLabelStyle: TextStyle(
        color: primaryBlue,
        fontWeight: FontWeight.w600,
      ),

      hintStyle: TextStyle(
        color: secondaryText.withValues(
          alpha: 0.60,
        ),
      ),

      prefixIcon: Icon(
        icon,
        color: primaryBlue,
      ),

      suffixText: suffixText,

      suffixStyle: TextStyle(
        color: secondaryText,
        fontWeight: FontWeight.w600,
      ),

      filled: true,

      fillColor: cardBackground,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide(
          color:
              primaryBlue.withValues(
            alpha: 0.20,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primaryBlue,
          width: 1.4,
        ),
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide(
          color:
              primaryBlue.withValues(
            alpha: 0.20,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isMinuteBased =
        selectedUnit == 'minutes';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:
              Alignment.topCenter,
          end:
              Alignment.bottomCenter,
          colors: [
            backgroundTop,
            backgroundMiddle,
            backgroundBottom,
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

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryText,
              size: 20,
            ),
          ),

          title: Text(
            isEditing
                ? 'Edit Habit'
                : 'Add Habit',
            style: TextStyle(
              color: primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: Stack(
          children: [
            // --------------------------------------------------
            // BACKGROUND GLOWS
            // --------------------------------------------------

            Positioned(
              top: -100,
              right: -130,
              child: _glow(
                size: 330,
                color: blueGlow,
                opacity: 0.13,
              ),
            ),

            Positioned(
              top: 360,
              left: -150,
              child: _glow(
                size: 350,
                color: primaryBlue,
                opacity: 0.09,
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
                10,
                20,
                35,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ============================================
                  // HEADING
                  // ============================================

                  Text(
                    isEditing
                        ? 'Update your habit ✨'
                        : 'Create a new habit ✨',
                    style:
                        TextStyle(
                      fontSize: 29,
                      fontWeight:
                          FontWeight.w800,
                      color: primaryText,
                      letterSpacing: -0.7,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isEditing
                        ? 'Make changes while keeping your progress.'
                        : 'Small habits create big changes.',
                    style:
                        TextStyle(
                      fontSize: 15,
                      color: secondaryText,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ============================================
                  // HABIT NAME
                  // ============================================

                  Text(
                    'Habit name',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        titleController,
                    textInputAction:
                        TextInputAction.next,
                    style:
                        TextStyle(
                      color: primaryText,
                      fontSize: 15,
                    ),
                    cursorColor:
                        primaryBlue,
                    decoration:
                        _inputDecoration(
                      label: 'Habit name',
                      hint:
                          'e.g. Drink Water',
                      icon: Icons
                          .check_circle_outline_rounded,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // DESCRIPTION
                  // ============================================

                  Text(
                    'Description',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        subtitleController,
                    textInputAction:
                        TextInputAction.next,
                    style:
                        TextStyle(
                      color: primaryText,
                      fontSize: 15,
                    ),
                    cursorColor:
                        primaryBlue,
                    decoration:
                        _inputDecoration(
                      label: 'Description',
                      hint:
                          'e.g. Stay hydrated',
                      icon:
                          Icons.notes_rounded,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // DAILY GOAL
                  // ============================================

                  Text(
                    'Daily goal',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        goalController,
                    keyboardType:
                        TextInputType.number,
                    textInputAction:
                        TextInputAction.next,
                    style:
                        TextStyle(
                      color: primaryText,
                      fontSize: 15,
                    ),
                    cursorColor:
                        primaryBlue,
                    decoration:
                        _inputDecoration(
                      label: 'Daily goal',
                      hint: 'e.g. 8',
                      icon:
                          Icons.flag_rounded,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // UNIT
                  // ============================================

                  Text(
                    'Unit',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration:
                        BoxDecoration(
                      color: cardBackground,
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                      border: Border.all(
                        color:
                            primaryBlue.withValues(
                          alpha: 0.20,
                        ),
                      ),
                    ),
                    child:
                        DropdownButtonHideUnderline(
                      child:
                          DropdownButton<String>(
                        value:
                            selectedUnit,
                        isExpanded: true,
                        dropdownColor:
                            cardBackground,
                        icon:
                            Icon(
                          Icons
                              .keyboard_arrow_down_rounded,
                          color:
                              primaryBlue,
                        ),
                        style:
                            TextStyle(
                          color:
                              primaryText,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                        ),
                        items:
                            const [
                          DropdownMenuItem(
                            value:
                                'sessions',
                            child: Text(
                              'Sessions',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'glasses',
                            child: Text(
                              'Glasses',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'pages',
                            child: Text(
                              'Pages',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'minutes',
                            child: Text(
                              'Minutes',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                'times',
                            child: Text(
                              'Times',
                            ),
                          ),
                        ],
                        onChanged:
                            (value) {
                          if (value ==
                              null) {
                            return;
                          }

                          setState(() {
                            selectedUnit =
                                value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // TIMER
                  // ============================================

                  if (!isMinuteBased)
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timer per session',
                          style:
                              TextStyle(
                            color:
                                primaryText,
                            fontSize:
                                14,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        TextField(
                          controller:
                              timerController,
                          keyboardType:
                              TextInputType
                                  .number,
                          style:
                              TextStyle(
                            color:
                                primaryText,
                            fontSize:
                                15,
                          ),
                          cursorColor:
                              primaryBlue,
                          decoration:
                              _inputDecoration(
                            label:
                                'Timer per session (minutes)',
                            hint:
                                'e.g. 25',
                            icon:
                                Icons
                                    .timer_outlined,
                            suffixText:
                                'min',
                          ),
                        ),
                      ],
                    )
                  else
                    _buildMinuteInfoCard(),

                  const SizedBox(height: 30),

                  // ============================================
                  // XP INFO
                  // ============================================

                  _buildXpInfoCard(),

                  const SizedBox(height: 24),

                  // ============================================
                  // SAVE / UPDATE BUTTON
                  // ============================================

                  SizedBox(
                    width: double.infinity,
                    height: 57,
                    child: Container(
                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end:
                              Alignment.bottomRight,
                          colors: [
                            gradientBlueLight,
                            gradientBlueDark,
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),
                        border:
                            Border.all(
                          color:
                              brightBlue.withValues(
                            alpha: 0.65,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                primaryBlue
                                    .withValues(
                              alpha: 0.28,
                            ),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Material(
                        color:
                            Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(
                            17,
                          ),
                          onTap:
                              saveHabit,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                isEditing
                                    ? Icons
                                        .save_rounded
                                    : Icons
                                        .add_task_rounded,
                                color:
                                    Colors.white,
                                size: 21,
                              ),

                              const SizedBox(
                                width: 9,
                              ),

                              Text(
                                isEditing
                                    ? 'Update Habit'
                                    : 'Save Habit',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      16,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MINUTE INFO CARD
  // ============================================================

  Widget _buildMinuteInfoCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            cardBackground,
            softBlue,
          ],
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              primaryBlue.withValues(
            alpha: 0.25,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                primaryBlue.withValues(
              alpha: 0.09,
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  gradientBlueLight,
                  gradientBlueDark,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Timer',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Timer will automatically match '
                  'your daily goal.',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    height: 1.35,
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
  // XP INFO CARD
  // ============================================================

  Widget _buildXpInfoCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            cardBackground,
            backgroundMiddle,
          ],
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              xpOrange.withValues(
            alpha: 0.40,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                xpOrange.withValues(
              alpha: 0.07,
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  xpOrange,
                  xpDark,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Earn XP',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete your daily goal to earn '
                  '10 XP and build your level.',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '+10 XP',
            style: TextStyle(
              color: xpDark,
              fontSize: 13,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BACKGROUND GLOW
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
          shape: BoxShape.circle,
          gradient:
              RadialGradient(
            colors: [
              color.withValues(
                alpha: opacity,
              ),
              color.withValues(
                alpha: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}