import 'package:hive_flutter/hive_flutter.dart';

import '../models/habit.dart';

class HabitDatabase {
  // ============================================================
  // SINGLETON
  // ============================================================

  static final HabitDatabase instance = HabitDatabase._internal();

  factory HabitDatabase() {
    return instance;
  }

  HabitDatabase._internal();

  // ============================================================
  // HIVE BOX
  // ============================================================

  static const String habitsBoxName = 'habits_box';

  // ============================================================
  // STORAGE KEYS
  // ============================================================

  static const String _totalXpKey = 'total_xp';
  static const String _profileNameKey = 'profile_name';
  static const String _profileBioKey = 'profile_bio';
  static const String _profileAvatarKey = 'profile_avatar';
  static const String _unlockedAchievementsKey =
      'unlocked_achievements';
  static const String _themeModeKey = 'theme_mode';

  // ============================================================
  // BOX
  // ============================================================

  Box<dynamic>? _habitsBox;

  bool _initialized = false;

  Future<void>? _initializationFuture;

  // ============================================================
  // INITIALIZATION STATE
  // ============================================================

  bool get isInitialized => _initialized;

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

    _initializationFuture = _initialize();

    return _initializationFuture!;
  }

// correct version of the _initialize method

  // Future<void> _initialize() async {
  //   try {
  //     await Hive.initFlutter();

  //     _habitsBox = await Hive.openBox<dynamic>(
  //       habitsBoxName,
  //     );

  //     _initialized = true;
  //   } catch (_) {
  //     _initializationFuture = null;
  //     rethrow;
  //   }
  // }


  // below is the diagonostic version
  Future<void> _initialize() async {
  try {
    final stopwatch = Stopwatch()..start();

    print(
      'STARTUP_DB: Hive.initFlutter START',
    );

    await Hive.initFlutter();

    print(
      'STARTUP_DB: Hive.initFlutter END '
      '${stopwatch.elapsedMilliseconds} ms',
    );

    print(
      'STARTUP_DB: Hive.openBox START',
    );

    _habitsBox = await Hive.openBox<dynamic>(
      habitsBoxName,
    );

    print(
      'STARTUP_DB: Hive.openBox END '
      '${stopwatch.elapsedMilliseconds} ms',
    );

    _initialized = true;

    print(
      'STARTUP_DB: database initialization COMPLETE '
      '${stopwatch.elapsedMilliseconds} ms',
    );
  } catch (_) {
    _initializationFuture = null;
    rethrow;
  }
}

  // ============================================================
  // HABITS
  // ============================================================

  List<Habit> loadHabits() {
    _checkInitialized();

    final box = _box;

    final List<Habit> loadedHabits = [];

    for (final key in box.keys) {
      final dynamic data = box.get(key);

      if (data is Map &&
          data.containsKey('id') &&
          data.containsKey('title')) {
        loadedHabits.add(
          _habitFromMap(
            Map<dynamic, dynamic>.from(data),
          ),
        );
      }
    }

    return loadedHabits;
  }

  Future<void> saveHabits(
    List<Habit> habits,
  ) async {
    _checkInitialized();

    final box = _box;

    final habitKeys = box.keys.where(
      (key) {
        final value = box.get(key);

        return value is Map &&
            value.containsKey('id') &&
            value.containsKey('title');
      },
    ).toList();

    for (final key in habitKeys) {
      await box.delete(key);
    }

    for (final habit in habits) {
      await box.put(
        habit.id,
        _habitToMap(habit),
      );
    }
  }

  Future<void> saveHabit(
    Habit habit,
  ) async {
    _checkInitialized();

    await _box.put(
      habit.id,
      _habitToMap(habit),
    );
  }

  Future<void> deleteHabit(
    String id,
  ) async {
    _checkInitialized();

    await _box.delete(id);
  }

  Future<void> clearAllHabits() async {
    _checkInitialized();

    final box = _box;

    final habitKeys = box.keys.where(
      (key) {
        final value = box.get(key);

        return value is Map &&
            value.containsKey('id') &&
            value.containsKey('title');
      },
    ).toList();

    for (final key in habitKeys) {
      await box.delete(key);
    }
  }

  // ============================================================
  // XP
  // ============================================================

  int loadTotalXp() {
    _checkInitialized();

    final dynamic value = _box.get(
      _totalXpKey,
      defaultValue: 0,
    );

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  Future<void> saveTotalXp(
    int totalXp,
  ) async {
    _checkInitialized();

    await _box.put(
      _totalXpKey,
      totalXp,
    );
  }

  // ============================================================
  // PROFILE NAME
  // ============================================================

  String loadProfileName() {
    _checkInitialized();

    final dynamic value = _box.get(
      _profileNameKey,
      defaultValue: 'HabitPixel User',
    );

    if (value is String &&
        value.trim().isNotEmpty) {
      return value.trim();
    }

    return 'HabitPixel User';
  }

  Future<void> saveProfileName(
    String name,
  ) async {
    _checkInitialized();

    await _box.put(
      _profileNameKey,
      name.trim(),
    );
  }

  // ============================================================
  // PROFILE BIO
  // ============================================================

  String loadProfileBio() {
    _checkInitialized();

    final dynamic value = _box.get(
      _profileBioKey,
      defaultValue:
          'Building better habits, one day at a time.',
    );

    if (value is String) {
      return value;
    }

    return 'Building better habits, one day at a time.';
  }

  Future<void> saveProfileBio(
    String bio,
  ) async {
    _checkInitialized();

    await _box.put(
      _profileBioKey,
      bio,
    );
  }

  // ============================================================
  // PROFILE AVATAR
  // ============================================================

  int loadProfileAvatar() {
    _checkInitialized();

    final dynamic value = _box.get(
      _profileAvatarKey,
      defaultValue: 0,
    );

    if (value is int &&
        value >= 0) {
      return value;
    }

    if (value is num &&
        value >= 0) {
      return value.toInt();
    }

    return 0;
  }

  Future<void> saveProfileAvatar(
    int avatar,
  ) async {
    _checkInitialized();

    await _box.put(
      _profileAvatarKey,
      avatar,
    );
  }

  // ============================================================
  // ACHIEVEMENTS
  // ============================================================

  List<String> loadUnlockedAchievements() {
    _checkInitialized();

    final dynamic value = _box.get(
      _unlockedAchievementsKey,
      defaultValue: <dynamic>[],
    );

    if (value is List) {
      return value
          .map(
            (item) => item.toString(),
          )
          .toList();
    }

    return [];
  }

  Future<void> saveUnlockedAchievements(
    List<String> achievementIds,
  ) async {
    _checkInitialized();

    await _box.put(
      _unlockedAchievementsKey,
      achievementIds,
    );
  }

  // ============================================================
  // THEME
  // ============================================================

  String loadThemeMode() {
    _checkInitialized();

    final dynamic value = _box.get(
      _themeModeKey,
      defaultValue: 'light',
    );

    if (value == 'dark') {
      return 'dark';
    }

    return 'light';
  }

  Future<void> saveThemeMode(
    String mode,
  ) async {
    _checkInitialized();

    await _box.put(
      _themeModeKey,
      mode == 'dark' ? 'dark' : 'light',
    );
  }

  // ============================================================
  // HABIT CONVERSION
  // ============================================================

  Map<String, dynamic> _habitToMap(
    Habit habit,
  ) {
    return {
      'id': habit.id,
      'title': habit.title,
      'subtitle': habit.subtitle,
      'streak': habit.streak,
      'goal': habit.goal,
      'progress': habit.progress,
      'unit': habit.unit,
      'timerMinutes': habit.timerMinutes,
      'completed': habit.completed,
      'xp': habit.xp,
      'lastCompletedDate':
          habit.lastCompletedDate?.millisecondsSinceEpoch,
      'lastActivityDate':
          habit.lastActivityDate?.millisecondsSinceEpoch,
      'lastXpDate':
          habit.lastXpDate?.millisecondsSinceEpoch,
    };
  }

  Habit _habitFromMap(
    Map<dynamic, dynamic> data,
  ) {
    return Habit(
      id: data['id']?.toString(),
      title: data['title']?.toString() ?? '',
      subtitle: data['subtitle']?.toString() ?? '',
      streak: _toInt(data['streak']),
      goal: _toInt(data['goal']),
      progress: _toInt(data['progress']),
      unit: data['unit']?.toString() ?? 'times',
      timerMinutes: _toInt(
        data['timerMinutes'],
        fallback: 25,
      ),
      completed: data['completed'] == true,
      xp: _toInt(data['xp']),
      lastCompletedDate:
          _dateFromMilliseconds(
        data['lastCompletedDate'],
      ),
      lastActivityDate:
          _dateFromMilliseconds(
        data['lastActivityDate'],
      ),
      lastXpDate:
          _dateFromMilliseconds(
        data['lastXpDate'],
      ),
    );
  }

  // ============================================================
  // INTEGER CONVERSION
  // ============================================================

  int _toInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return fallback;
  }

  // ============================================================
  // DATE CONVERSION
  // ============================================================

  DateTime? _dateFromMilliseconds(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        value,
      );
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt(),
      );
    }

    return null;
  }

  // ============================================================
  // INTERNAL BOX ACCESS
  // ============================================================

  Box<dynamic> get _box {
    final box = _habitsBox;

    if (!_initialized || box == null) {
      throw StateError(
        'HabitDatabase has not been initialized.',
      );
    }

    return box;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  void _checkInitialized() {
    if (!_initialized ||
        _habitsBox == null) {
      throw StateError(
        'HabitDatabase has not been initialized.',
      );
    }
  }
}