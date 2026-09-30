import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import 'habit_database.dart';

class HabitStore extends ChangeNotifier {
  // ============================================================
  // SINGLETON
  // ============================================================

  static final HabitStore instance =
      HabitStore._internal();

  factory HabitStore() {
    return instance;
  }

  HabitStore._internal();

  // ============================================================
  // DATABASE
  // ============================================================

  final HabitDatabase _database =
      HabitDatabase.instance;

  // ============================================================
  // INITIALIZATION STATE
  // ============================================================

  bool _initialized = false;

  Future<void>? _initializationFuture;

  bool get isInitialized =>
      _initialized;

  bool get isInitializing =>
      _initializationFuture != null &&
      !_initialized;

  // ============================================================
  // PROFILE SETTINGS
  // ============================================================

  static const String defaultProfileName =
      'Habit Hero';

  static const String defaultProfileBio =
      'Building better habits, one day at a time.';

  static const int defaultProfileAvatar =
      0;

  String _profileName =
      defaultProfileName;

  String _profileBio =
      defaultProfileBio;

  int _profileAvatar =
      defaultProfileAvatar;

  // ------------------------------------------------------------
  // PROFILE GETTERS
  // ------------------------------------------------------------

  String get profileName =>
      _profileName;

  String get profileBio =>
      _profileBio;

  int get profileAvatar =>
      _profileAvatar;

  // ============================================================
  // XP SYSTEM
  // ============================================================

  static const int xpPerHabit =
      10;

  static const int ticTacToeWinXp =
      30;

  static const int ticTacToeDrawXp =
      10;

  static const int ticTacToeLossXp =
      0;

  int _totalXp =
      0;

  int _lastAwardedXp =
      0;

  int get totalXp =>
      _totalXp;

  int get lastAwardedXp =>
      _lastAwardedXp;

  // ============================================================
  // ONE-TIME DEMO RESET
  // ============================================================

  static const bool resetDemoProgress =
      false;

  // ============================================================
  // ACHIEVEMENTS
  // ============================================================

  final Set<String> _unlockedAchievements =
      {};

  List<String> get unlockedAchievements =>
      List.unmodifiable(
        _unlockedAchievements,
      );

  bool isAchievementUnlocked(
    String id,
  ) {
    return _unlockedAchievements.contains(
      id,
    );
  }

  // ============================================================
  // LEVEL SYSTEM
  // ============================================================

  int get currentLevel {
    return (_totalXp ~/ 100) + 1;
  }

  int get xpIntoCurrentLevel {
    return _totalXp % 100;
  }

  int get xpNeededForNextLevel {
    return 100 - xpIntoCurrentLevel;
  }

  double get levelProgress {
    return xpIntoCurrentLevel / 100;
  }

  // ============================================================
  // PROFILE LEVEL DISPLAY HELPERS
  // ============================================================

  int get xpAtStartOfCurrentLevel {
    return (currentLevel - 1) * 100;
  }

  int get xpForNextLevel {
    return currentLevel * 100;
  }

  // ============================================================
  // HABITS
  // ============================================================

  final List<Habit> habits =
      [];

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> init() {
    if (_initialized) {
      return Future.value();
    }

    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    _initializationFuture =
        _initialize();

    return _initializationFuture!;
  }

  Future<void> _initialize() async {
    try {
      // ----------------------------------------------------------
      // DATABASE INITIALIZATION
      // ----------------------------------------------------------

      await _database.init();

      // ----------------------------------------------------------
      // LOAD PROFILE
      // ----------------------------------------------------------

      _loadProfile();

      // ----------------------------------------------------------
      // LOAD XP
      // ----------------------------------------------------------

      _totalXp =
          _database.loadTotalXp();

      // ----------------------------------------------------------
      // LOAD ACHIEVEMENTS
      // ----------------------------------------------------------

      final savedAchievements =
          _database.loadUnlockedAchievements();

      _unlockedAchievements.clear();

      _unlockedAchievements.addAll(
        savedAchievements,
      );

      // ==========================================================
      // ONE-TIME DEMO RESET
      // ==========================================================

      if (resetDemoProgress) {
        // --------------------------------------------------------
        // CLEAR IN-MEMORY DATA
        // --------------------------------------------------------

        habits.clear();

        _unlockedAchievements.clear();

        // --------------------------------------------------------
        // RESET XP
        // --------------------------------------------------------

        _totalXp = 0;

        _lastAwardedXp = 0;

        // --------------------------------------------------------
        // RESET PROFILE
        // --------------------------------------------------------

        _profileName =
            defaultProfileName;

        _profileBio =
            defaultProfileBio;

        _profileAvatar =
            defaultProfileAvatar;

        await _saveProfile();

        // --------------------------------------------------------
        // DELETE ALL SAVED HABITS
        // --------------------------------------------------------

        await _database.clearAllHabits();

        // --------------------------------------------------------
        // RESET ACHIEVEMENTS
        // --------------------------------------------------------

        await _database.saveUnlockedAchievements(
          [],
        );

        // --------------------------------------------------------
        // RESET GLOBAL XP
        // --------------------------------------------------------

        await _database.saveTotalXp(
          0,
        );

        // --------------------------------------------------------
        // CREATE FRESH DEFAULT HABITS
        // --------------------------------------------------------

        habits.addAll(
          _createDefaultHabits(),
        );

        // --------------------------------------------------------
        // SAVE FRESH HABITS
        // --------------------------------------------------------

        await _database.saveHabits(
          habits,
        );
      } else {
        // ========================================================
        // NORMAL APP START
        // ========================================================

        final savedHabits =
            _database.loadHabits();

        if (savedHabits.isEmpty) {
          habits.addAll(
            _createDefaultHabits(),
          );

          await _database.saveHabits(
            habits,
          );
        } else {
          habits.addAll(
            savedHabits,
          );
        }
      }

      // ==========================================================
      // NEW DAY CHECK
      // ==========================================================

      await resetForNewDay();

      // ==========================================================
      // ACHIEVEMENTS
      // ==========================================================

      if (!resetDemoProgress) {
        await _checkAchievements(
          notify: false,
        );
      }

      // Mark initialized before notifying listeners so that
      // widgets responding to this notification can safely use
      // the fully loaded store.
      _initialized = true;

      // ==========================================================
      // NOTIFY UI
      // ==========================================================

      notifyListeners();
    } catch (_) {
      // Allow a future initialization attempt if initialization
      // fails.
      _initializationFuture = null;
      rethrow;
    }
  }

  // ============================================================
  // ENSURE INITIALIZED
  // ============================================================

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    await init();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  void _loadProfile() {
    _profileName =
        _database.loadProfileName();

    _profileBio =
        _database.loadProfileBio();

    _profileAvatar =
        _database.loadProfileAvatar();
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
    await _database.saveProfileName(
      _profileName,
    );

    await _database.saveProfileBio(
      _profileBio,
    );

    await _database.saveProfileAvatar(
      _profileAvatar,
    );
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> updateProfile({
    String? name,
    String? bio,
    int? avatar,
  }) async {
    await _ensureInitialized();

    if (name != null) {
      final trimmedName =
          name.trim();

      if (trimmedName.isNotEmpty) {
        _profileName =
            trimmedName;
      }
    }

    if (bio != null) {
      _profileBio =
          bio.trim();
    }

    if (avatar != null &&
        avatar >= 0) {
      _profileAvatar =
          avatar;
    }

    await _saveProfile();

    notifyListeners();
  }

  // ============================================================
  // UPDATE PROFILE NAME
  // ============================================================

  Future<void> updateProfileName(
    String name,
  ) async {
    await _ensureInitialized();

    final trimmedName =
        name.trim();

    if (trimmedName.isEmpty) {
      return;
    }

    _profileName =
        trimmedName;

    await _saveProfile();

    notifyListeners();
  }

  // ============================================================
  // UPDATE PROFILE BIO
  // ============================================================

  Future<void> updateProfileBio(
    String bio,
  ) async {
    await _ensureInitialized();

    _profileBio =
        bio.trim();

    await _saveProfile();

    notifyListeners();
  }

  // ============================================================
  // UPDATE PROFILE AVATAR
  // ============================================================

  Future<void> updateProfileAvatar(
    int avatar,
  ) async {
    await _ensureInitialized();

    if (avatar < 0) {
      return;
    }

    _profileAvatar =
        avatar;

    await _saveProfile();

    notifyListeners();
  }

  // ============================================================
  // RESET PROFILE
  // ============================================================

  Future<void> resetProfile() async {
    await _ensureInitialized();

    _profileName =
        defaultProfileName;

    _profileBio =
        defaultProfileBio;

    _profileAvatar =
        defaultProfileAvatar;

    await _saveProfile();

    notifyListeners();
  }

  // ============================================================
  // DEFAULT HABITS
  // ============================================================

  List<Habit> _createDefaultHabits() {
    return [
      Habit(
        title: 'Drink Water',
        subtitle: '8 glasses',
        streak: 0,
        goal: 8,
        progress: 0,
        unit: 'glasses',
        completed: false,
      ),
      Habit(
        title: 'Read 20 Minutes',
        subtitle: 'Personal growth',
        streak: 0,
        goal: 20,
        progress: 0,
        unit: 'minutes',
        timerMinutes: 20,
        completed: false,
      ),
      Habit(
        title: '30 Minute Walk',
        subtitle: 'Stay active',
        streak: 0,
        goal: 30,
        progress: 0,
        unit: 'minutes',
        timerMinutes: 30,
        completed: false,
      ),
    ];
  }

  // ============================================================
  // RESET FOR NEW DAY
  // ============================================================

  Future<void> resetForNewDay() async {
    // HomeScreen can call this during its lifecycle before the
    // background initialization has completed. In that situation
    // simply leave the work to the initialization sequence.
    if (!_database.isInitialized) {
      return;
    }

    final now =
        DateTime.now();

    final today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    bool changed = false;

    for (final habit in habits) {
      if (habit.lastActivityDate == null) {
        habit.lastActivityDate =
            today;

        await _database.saveHabit(
          habit,
        );

        changed = true;

        continue;
      }

      final lastActivity =
          DateTime(
        habit.lastActivityDate!.year,
        habit.lastActivityDate!.month,
        habit.lastActivityDate!.day,
      );

      if (lastActivity.isBefore(
        today,
      )) {
        habit.progress = 0;

        habit.completed = false;

        habit.lastActivityDate =
            today;

        await _database.saveHabit(
          habit,
        );

        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  // ============================================================
  // MARK HABIT ACTIVE
  // ============================================================

  Future<void> markHabitActive(
    Habit habit,
  ) async {
    await _ensureInitialized();

    final now =
        DateTime.now();

    habit.lastActivityDate =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    await _database.saveHabit(
      habit,
    );

    notifyListeners();
  }

  // ============================================================
  // FIND HABIT
  // ============================================================

  Habit? getById(
    String id,
  ) {
    for (final habit in habits) {
      if (habit.id == id) {
        return habit;
      }
    }

    return null;
  }

  // ============================================================
  // ADD HABIT
  // ============================================================

  Future<void> add(
    Habit habit,
  ) async {
    await _ensureInitialized();

    habits.add(
      habit,
    );

    await _database.saveHabit(
      habit,
    );

    await _checkAchievements();

    notifyListeners();
  }

  // ============================================================
  // UPDATE HABIT
  // ============================================================

  Future<void> update(
    Habit habit,
  ) async {
    await _ensureInitialized();

    final index =
        habits.indexWhere(
      (item) =>
          item.id == habit.id,
    );

    if (index != -1) {
      habits[index] =
          habit;

      await _database.saveHabit(
        habit,
      );

      await _checkAchievements();

      notifyListeners();
    }
  }

  // ============================================================
  // DELETE HABIT
  // ============================================================

  Future<void> delete(
    String id,
  ) async {
    await _ensureInitialized();

    habits.removeWhere(
      (habit) =>
          habit.id == id,
    );

    await _database.deleteHabit(
      id,
    );

    await _checkAchievements();

    notifyListeners();
  }

  // ============================================================
  // COMPLETE HABIT FOR TODAY
  // ============================================================

  Future<int> completeHabitForToday(
    Habit habit,
  ) async {
    await _ensureInitialized();

    final now =
        DateTime.now();

    final today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    _lastAwardedXp = 0;

    if (habit.lastCompletedDate !=
        null) {
      final lastCompleted =
          DateTime(
        habit.lastCompletedDate!.year,
        habit.lastCompletedDate!.month,
        habit.lastCompletedDate!.day,
      );

      if (lastCompleted ==
          today) {
        return 0;
      }

      final yesterday =
          today.subtract(
        const Duration(
          days: 1,
        ),
      );

      if (lastCompleted ==
          yesterday) {
        habit.streak++;
      } else {
        habit.streak = 1;
      }
    } else {
      habit.streak = 1;
    }

    habit.lastCompletedDate =
        today;

    habit.lastActivityDate =
        today;

    habit.completed =
        true;

    habit.xp +=
        xpPerHabit;

    habit.lastXpDate =
        today;

    _totalXp +=
        xpPerHabit;

    _lastAwardedXp =
        xpPerHabit;

    await _database.saveHabit(
      habit,
    );

    await _database.saveTotalXp(
      _totalXp,
    );

    await _checkAchievements();

    notifyListeners();

    return xpPerHabit;
  }

  // ============================================================
  // GAME XP
  // ============================================================

  Future<int> awardGameXp(
    int xp,
  ) async {
    await _ensureInitialized();

    _lastAwardedXp = 0;

    if (xp <= 0) {
      return 0;
    }

    _totalXp +=
        xp;

    _lastAwardedXp =
        xp;

    await _database.saveTotalXp(
      _totalXp,
    );

    await _checkAchievements();

    notifyListeners();

    return xp;
  }

  // ============================================================
  // TIC-TAC-TOE XP HELPERS
  // ============================================================

  int get ticTacToeWinReward {
    return ticTacToeWinXp;
  }

  int get ticTacToeDrawReward {
    return ticTacToeDrawXp;
  }

  int get ticTacToeLossReward {
    return ticTacToeLossXp;
  }

  // ============================================================
  // CHECK ACHIEVEMENTS
  // ============================================================

  Future<void> _checkAchievements({
    bool notify = true,
  }) async {
    final List<_AchievementRule>
        rules = [
      _AchievementRule(
        id: 'first_step',
        condition:
            totalHabits >= 1,
      ),
      _AchievementRule(
        id: 'getting_started',
        condition:
            totalHabits >= 3,
      ),
      _AchievementRule(
        id: 'habit_builder',
        condition:
            totalHabits >= 5,
      ),
      _AchievementRule(
        id: 'first_win',
        condition:
            completedHabits >= 1,
      ),
      _AchievementRule(
        id: 'daily_champion',
        condition:
            totalHabits > 0 &&
            completedHabits ==
                totalHabits,
      ),
      _AchievementRule(
        id: 'streak_starter',
        condition:
            bestStreak >= 3,
      ),
      _AchievementRule(
        id: 'on_fire',
        condition:
            bestStreak >= 7,
      ),
      _AchievementRule(
        id: 'level_up',
        condition:
            currentLevel >= 5,
      ),
      _AchievementRule(
        id: 'xp_master',
        condition:
            totalXp >= 1000,
      ),
    ];

    bool changed =
        false;

    for (final rule in rules) {
      if (!rule.condition) {
        continue;
      }

      if (_unlockedAchievements.contains(
        rule.id,
      )) {
        continue;
      }

      _unlockedAchievements.add(
        rule.id,
      );

      changed =
          true;
    }

    if (!changed) {
      return;
    }

    await _database.saveUnlockedAchievements(
      _unlockedAchievements.toList(),
    );

    if (notify) {
      notifyListeners();
    }
  }

  // ============================================================
  // ACHIEVEMENT STATS
  // ============================================================

  int get totalHabits {
    return habits.length;
  }

  int get completedHabits {
    return habits
        .where(
          (habit) =>
              habit.completed,
        )
        .length;
  }

  int get bestStreak {
    int highest = 0;

    for (final habit in habits) {
      if (habit.streak >
          highest) {
        highest =
            habit.streak;
      }
    }

    return highest;
  }

  // ============================================================
  // PROFILE STATISTICS
  // ============================================================

  int get unlockedAchievementCount {
    return _unlockedAchievements.length;
  }

  int get totalAchievementCount {
    return 9;
  }

  double get achievementProgress {
    if (totalAchievementCount ==
        0) {
      return 0;
    }

    return unlockedAchievementCount /
        totalAchievementCount;
  }

  // ============================================================
  // PROFILE SUMMARY
  // ============================================================

  int get profileLevel {
    return currentLevel;
  }

  int get profileXp {
    return totalXp;
  }

  int get profileStreak {
    return bestStreak;
  }

  int get profileCompletedHabits {
    return completedHabits;
  }

  int get profileTotalHabits {
    return totalHabits;
  }

  int get profileAchievements {
    return unlockedAchievementCount;
  }

  // ============================================================
  // CLEAR LAST XP
  // ============================================================

  void clearLastAwardedXp() {
    _lastAwardedXp = 0;
  }
}

// ================================================================
// ACHIEVEMENT RULE
// ================================================================

class _AchievementRule {
  final String id;

  final bool condition;

  const _AchievementRule({
    required this.id,
    required this.condition,
  });
}