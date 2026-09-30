import 'package:flutter/material.dart';

import '../services/habit_store.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HabitStore _store = HabitStore.instance;

  final ThemeController _themeController =
      ThemeController.instance;

  static const List<IconData> _avatars = [
    Icons.person,
    Icons.face,
    Icons.sentiment_satisfied,
    Icons.emoji_emotions,
    Icons.auto_awesome,
    Icons.rocket_launch,
    Icons.sports_esports,
    Icons.psychology,
  ];

  // ============================================================
  // THEME-AWARE COLORS
  // ============================================================

  bool get _isDark =>
      _themeController.isDarkMode;

  Color get _background =>
      _isDark
          ? AppColors.darkBackgroundBottom
          : AppColors.backgroundBottom;

  Color get _backgroundTop =>
      _isDark
          ? AppColors.darkBackgroundTop
          : AppColors.backgroundTop;

  Color get _backgroundMiddle =>
      _isDark
          ? AppColors.darkBackgroundMiddle
          : AppColors.backgroundMiddle;

  Color get _card =>
      _isDark
          ? AppColors.darkCardBackground
          : AppColors.cardBackground;

  Color get _primary =>
      _isDark
          ? AppColors.darkPrimaryBlue
          : AppColors.primaryBlue;

  Color get _primaryLight =>
      _isDark
          ? AppColors.darkSoftBlue
          : AppColors.softBlue;

  Color get _primaryBright =>
      _isDark
          ? AppColors.darkBrightBlue
          : AppColors.brightBlue;

  Color get _primaryDark =>
      _isDark
          ? AppColors.darkDeepBlue
          : AppColors.deepBlue;

  Color get _textPrimary =>
      _isDark
          ? AppColors.darkPrimaryText
          : AppColors.primaryText;

  Color get _textSecondary =>
      _isDark
          ? AppColors.darkSecondaryText
          : AppColors.secondaryText;

  Color get _border =>
      _isDark
          ? AppColors.darkCardBorder
          : AppColors.cardBorder;

  Color get _softViolet =>
      _isDark
          ? AppColors.darkSoftViolet
          : AppColors.softViolet;

  Color get _progressBackground =>
      _isDark
          ? AppColors.darkProgressBackground
          : AppColors.progressBackground;

  Color get _blueGlow =>
      _isDark
          ? AppColors.darkBlueGlow
          : AppColors.blueGlow;

  Color get _gradientBlueLight =>
      _isDark
          ? AppColors.darkGradientBlueLight
          : AppColors.gradientBlueLight;

  Color get _gradientBlueDark =>
      _isDark
          ? AppColors.darkGradientBlueDark
          : AppColors.gradientBlueDark;

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

  Color get _success =>
      _isDark
          ? AppColors.darkSuccess
          : AppColors.success;

  Color get _neonViolet =>
      _isDark
          ? AppColors.darkNeonViolet
          : AppColors.neonViolet;

  @override
  void initState() {
    super.initState();

    _store.addListener(
      _onStoreChanged,
    );

    _themeController.addListener(
      _onThemeChanged,
    );
  }

  @override
  void dispose() {
    _store.removeListener(
      _onStoreChanged,
    );

    _themeController.removeListener(
      _onThemeChanged,
    );

    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleTheme() {
    _themeController.toggleTheme();
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(
      text: _store.profileName,
    );

    final bioController = TextEditingController(
      text: _store.profileBio,
    );

    int selectedAvatar =
        _store.profileAvatar;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: _card,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Avatar',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          List.generate(
                        _avatars.length,
                        (index) {
                          final isSelected =
                              selectedAvatar ==
                                  index;

                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedAvatar =
                                    index;
                              });
                            },
                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    200,
                              ),
                              width: 48,
                              height: 48,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                gradient:
                                    isSelected
                                        ? LinearGradient(
                                            begin:
                                                Alignment.topLeft,
                                            end:
                                                Alignment.bottomRight,
                                            colors: [
                                              _gradientBlueLight,
                                              _gradientBlueDark,
                                            ],
                                          )
                                        : null,
                                color: isSelected
                                    ? null
                                    : _primaryLight,
                                border:
                                    Border.all(
                                  color: isSelected
                                      ? Colors
                                          .transparent
                                      : _border,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _avatars[index],
                                color: isSelected
                                    ? Colors.white
                                    : _primary,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller:
                          nameController,
                      style: TextStyle(
                        color: _textPrimary,
                      ),
                      textCapitalization:
                          TextCapitalization.words,
                      decoration:
                          InputDecoration(
                        labelText: 'Name',
                        labelStyle:
                            TextStyle(
                          color:
                              _textSecondary,
                        ),
                        prefixIcon:
                            Icon(
                          Icons
                              .person_outline,
                          color: _primary,
                        ),
                        filled: true,
                        fillColor:
                            _primaryLight,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              BorderSide(
                            color:
                                _primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          bioController,
                      style: TextStyle(
                        color: _textPrimary,
                      ),
                      maxLines: 3,
                      decoration:
                          InputDecoration(
                        labelText: 'Bio',
                        labelStyle:
                            TextStyle(
                          color:
                              _textSecondary,
                        ),
                        prefixIcon:
                            Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            bottom: 38,
                          ),
                          child: Icon(
                            Icons
                                .description_outlined,
                            color:
                                _primaryBright,
                          ),
                        ),
                        filled: true,
                        fillColor:
                            _primaryLight,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              BorderSide(
                            color:
                                _primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color:
                          _textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        _primary,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final name =
                        nameController
                            .text
                            .trim();

                    final bio =
                        bioController
                            .text
                            .trim();

                    if (name.isEmpty) {
                      return;
                    }

                    await _store
                        .updateProfile(
                      name: name,
                      bio: bio,
                      avatar:
                          selectedAvatar,
                    );

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profile updated successfully!',
                        ),
                      ),
                    );
                  },
                  child:
                      const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    bioController.dispose();
  }

  // ============================================================
  // RESET PROFILE
  // ============================================================

  Future<void> _resetProfile() async {
    final shouldReset =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _card,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),
          title: Text(
            'Reset Profile?',
            style: TextStyle(
              color: _textPrimary,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Text(
            'This will reset your profile name, bio, and avatar. Your habits and XP will not be affected.',
            style: TextStyle(
              color: _textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    _primary,
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
                  const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    await _store.resetProfile();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile reset successfully.',
        ),
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  IconData _getAvatarIcon() {
    final index =
        _store.profileAvatar;

    if (index < 0 ||
        index >= _avatars.length) {
      return _avatars[0];
    }

    return _avatars[index];
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
            _background,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _store
                  .resetForNewDay();
            },
            color: _primary,
            backgroundColor: _card,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                110,
              ),
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'Profile',
                          style:
                              TextStyle(
                            color:
                                _textPrimary,
                            fontSize: 28,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                            height: 4),
                        Text(
                          'Your habit journey',
                          style:
                              TextStyle(
                            color:
                                _textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed:
                          _showEditProfileDialog,
                      icon: Icon(
                        Icons
                            .edit_outlined,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 24),
                _buildProfileCard(),
                const SizedBox(
                    height: 20),
                _buildLevelCard(),
                const SizedBox(
                    height: 20),
                _buildStatistics(),
                const SizedBox(
                    height: 20),
                _buildAchievementProgress(),
                const SizedBox(
                    height: 20),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _buildProfileCard() {
    return Container(
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _card,
            _primaryLight,
          ],
        ),
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: _primary.withValues(
            alpha: 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: _blueGlow.withValues(
              alpha: 0.10,
            ),
            blurRadius: 24,
            offset:
                const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape:
                  BoxShape.circle,
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  _gradientBlueLight,
                  _gradientBlueDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _blueGlow.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 22,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _getAvatarIcon(),
              color:
                  Colors.white,
              size: 46,
            ),
          ),
          const SizedBox(
              height: 16),
          Text(
            _store.profileName,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  _textPrimary,
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
              height: 6),
          Text(
            _store.profileBio,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  _textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(
              height: 18),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration:
                BoxDecoration(
              color:
                  _primaryLight,
              borderRadius:
                  BorderRadius.circular(
                30,
              ),
              border: Border.all(
                color:
                    _primary.withValues(
                  alpha: 0.25,
                ),
              ),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons
                      .workspace_premium,
                  color:
                      _primary,
                  size: 18,
                ),
                const SizedBox(
                    width: 7),
                Text(
                  'LEVEL ${_store.currentLevel}',
                  style:
                      TextStyle(
                    color:
                        _primaryDark,
                    fontSize: 12,
                    fontWeight:
                        FontWeight
                            .bold,
                    letterSpacing: 1,
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
  // LEVEL CARD
  // ============================================================

  Widget _buildLevelCard() {
    final progress =
        _store.levelProgress;

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: _border,
        ),
        boxShadow: [
          BoxShadow(
            color:
                _blueGlow.withValues(
              alpha: 0.05,
            ),
            blurRadius: 16,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets
                            .all(10),
                    decoration:
                        BoxDecoration(
                      color:
                          _softViolet,
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      Icons
                          .bolt_rounded,
                      color:
                          _xpOrange,
                      size: 22,
                    ),
                  ),
                  const SizedBox(
                      width: 12),
                  Text(
                    'Level Progress',
                    style:
                        TextStyle(
                      color:
                          _textPrimary,
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${_store.totalXp} XP',
                style:
                    TextStyle(
                  color:
                      _xpDark,
                  fontSize: 14,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 18),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  progress.clamp(
                0.0,
                1.0,
              ),
              minHeight: 9,
              backgroundColor:
                  _progressBackground,
              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                _primary,
              ),
            ),
          ),
          const SizedBox(
              height: 10),
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                '${_store.xpIntoCurrentLevel} / 100 XP',
                style:
                    TextStyle(
                  color:
                      _textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '${_store.xpNeededForNextLevel} XP to Level ${_store.currentLevel + 1}',
                style:
                    TextStyle(
                  color:
                      _textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child:
              _buildStatCard(
            icon:
                Icons.local_fire_department,
            value:
                '${_store.bestStreak}',
            label:
                'Best Streak',
            iconColor:
                _streakOrange,
          ),
        ),
        const SizedBox(
            width: 12),
        Expanded(
          child:
              _buildStatCard(
            icon:
                Icons.check_circle_outline,
            value:
                '${_store.completedHabits}',
            label:
                'Completed',
            iconColor:
                _success,
          ),
        ),
        const SizedBox(
            width: 12),
        Expanded(
          child:
              _buildStatCard(
            icon:
                Icons.emoji_events_outlined,
            value:
                '${_store.unlockedAchievementCount}',
            label:
                'Badges',
            iconColor:
                _neonViolet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: _card,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: _border,
        ),
        boxShadow: [
          BoxShadow(
            color:
                _blueGlow.withValues(
              alpha: 0.04,
            ),
            blurRadius: 12,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(
              height: 9),
          Text(
            value,
            style: TextStyle(
              color:
                  _textPrimary,
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
              height: 4),
          Text(
            label,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  _textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACHIEVEMENT PROGRESS
  // ============================================================

  Widget _buildAchievementProgress() {
    final progress =
        _store.achievementProgress;

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: _border,
        ),
        boxShadow: [
          BoxShadow(
            color:
                _blueGlow.withValues(
              alpha: 0.05,
            ),
            blurRadius: 16,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(
                  10,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      _softViolet,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color:
                      _xpOrange,
                  size: 22,
                ),
              ),
              const SizedBox(
                  width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'Achievements',
                      style:
                          TextStyle(
                        color:
                            _textPrimary,
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    const SizedBox(
                        height: 3),
                    Text(
                      '${_store.unlockedAchievementCount} of ${_store.totalAchievementCount} unlocked',
                      style:
                          TextStyle(
                        color:
                            _textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style:
                    TextStyle(
                  color:
                      _primary,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 18),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  progress.clamp(
                0.0,
                1.0,
              ),
              minHeight: 8,
              backgroundColor:
                  _progressBackground,
              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                _primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

Widget _buildActions() {
  return Container(
    decoration: BoxDecoration(
      color: _card,
      borderRadius:
          BorderRadius.circular(22),
      border: Border.all(
        color: _border,
      ),
      boxShadow: [
        BoxShadow(
          color: _blueGlow.withValues(
            alpha: 0.05,
          ),
          blurRadius: 16,
          offset:
              const Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius:
          BorderRadius.circular(22),
      child: Material(
        color: _card,
        child: Column(
          children: [
            ListTile(
              leading:
                  _buildActionIcon(
                Icons.edit_outlined,
                _primary,
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Change your name, bio or avatar',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: _textSecondary,
              ),
              onTap:
                  _showEditProfileDialog,
            ),

            Divider(
              color: _border,
              height: 1,
            ),

            ListTile(
              leading:
                  _buildActionIcon(
                _themeController.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                _xpOrange,
              ),
              title: Text(
                'Appearance',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              subtitle: Text(
                _themeController.isDarkMode
                    ? 'Dark Mode'
                    : 'Light Mode',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Switch(
                value:
                    _themeController.isDarkMode,
                onChanged: (_) {
                  _toggleTheme();
                },
                activeThumbColor:
                    _primary,
                activeTrackColor:
                    _primaryLight,
              ),
              onTap: _toggleTheme,
            ),

            Divider(
              color: _border,
              height: 1,
            ),

            ListTile(
              leading:
                  _buildActionIcon(
                Icons.restart_alt_rounded,
                _streakOrange,
              ),
              title: Text(
                'Reset Profile',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Restore default profile information',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: _textSecondary,
              ),
              onTap: _resetProfile,
            ),
          ],
        ),
      ),
    ),
  );
}

  // ============================================================
  // ACTION ICON
  // ============================================================

  Widget _buildActionIcon(
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}