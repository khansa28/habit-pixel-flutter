
import 'dart:async';

import '../models/habit.dart';
import 'notification_service.dart';
import 'habit_store.dart';

class HabitTimerState {
  DateTime? endTime;

  int pausedRemainingSeconds;

  bool isRunning;

  bool isSessionCompleted;

  HabitTimerState({
    this.endTime,
    this.pausedRemainingSeconds = 0,
    this.isRunning = false,
    this.isSessionCompleted = false,
  });

  int get remainingSeconds {
    // ----------------------------------------------------------
    // RUNNING TIMER
    // ----------------------------------------------------------

    if (isRunning && endTime != null) {
      final difference =
          endTime!.difference(DateTime.now()).inSeconds;

      return difference > 0 ? difference : 0;
    }

    // ----------------------------------------------------------
    // PAUSED TIMER
    // ----------------------------------------------------------

    if (!isRunning && pausedRemainingSeconds > 0) {
      return pausedRemainingSeconds;
    }

    return 0;
  }
}

class HabitTimerService {
  // ------------------------------------------------------------
  // SINGLE INSTANCE
  // ------------------------------------------------------------

  static final HabitTimerService instance =
      HabitTimerService._internal();

  factory HabitTimerService() {
    return instance;
  }

  HabitTimerService._internal();

  // ------------------------------------------------------------
  // TIMER DATA
  // ------------------------------------------------------------

  final Map<Habit, HabitTimerState> _timers = {};

  final Map<Habit, Timer> _tickers = {};

  // ------------------------------------------------------------
  // LISTENERS
  // ------------------------------------------------------------

  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  // ------------------------------------------------------------
  // GET TIMER STATE
  // ------------------------------------------------------------

  HabitTimerState _getState(Habit habit) {
    return _timers.putIfAbsent(
      habit,
      () => HabitTimerState(),
    );
  }

  // ------------------------------------------------------------
  // GETTERS
  // ------------------------------------------------------------

  bool isRunning(Habit habit) {
    return _getState(habit).isRunning;
  }

  bool isSessionCompleted(Habit habit) {
    return _getState(habit).isSessionCompleted;
  }

  int remainingSeconds(Habit habit) {
    return _getState(habit).remainingSeconds;
  }

  // ------------------------------------------------------------
  // START / RESUME TIMER
  // ------------------------------------------------------------

  void start(Habit habit) {
    final state = _getState(habit);

    // Already running.
    if (state.isRunning) {
      return;
    }

    // Habit already completed.
    if (habit.progress >= habit.goal) {
      return;
    }

    int durationInSeconds;

    // ----------------------------------------------------------
    // RESUME PAUSED TIMER
    // ----------------------------------------------------------

    if (state.pausedRemainingSeconds > 0) {
      durationInSeconds =
          state.pausedRemainingSeconds;
    }

    // ----------------------------------------------------------
    // START NEW TIMER
    // ----------------------------------------------------------

    else {
      durationInSeconds =
          habit.timerMinutes * 60;
    }

    state.endTime = DateTime.now().add(
      Duration(
        seconds: durationInSeconds,
      ),
    );

    state.pausedRemainingSeconds = 0;

    state.isRunning = true;

    state.isSessionCompleted = false;

    // Mark this habit as active today.
    HabitStore.instance.markHabitActive(habit);

    _startTicker(habit);

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // START INTERNAL TICKER
  // ------------------------------------------------------------

  void _startTicker(Habit habit) {
    _tickers[habit]?.cancel();

    _tickers[habit] = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final state = _getState(habit);

        if (!state.isRunning ||
            state.endTime == null) {
          return;
        }

        if (DateTime.now().isBefore(
          state.endTime!,
        )) {
          _notifyListeners();
        } else {
          _finishTimer(habit);
        }
      },
    );
  }

  // ------------------------------------------------------------
  // PAUSE
  // ------------------------------------------------------------

  void pause(Habit habit) {
    final state = _getState(habit);

    if (!state.isRunning ||
        state.endTime == null) {
      return;
    }

    state.pausedRemainingSeconds =
        state.remainingSeconds;

    _tickers[habit]?.cancel();

    _tickers.remove(habit);

    state.isRunning = false;

    state.endTime = null;

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // RESET TIMER
  // ------------------------------------------------------------

  void reset(Habit habit) {
    _tickers[habit]?.cancel();

    _tickers.remove(habit);

    _timers[habit] =
        HabitTimerState();

    HabitStore.instance.clearLastAwardedXp();

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // FINISH TIMER
  // ------------------------------------------------------------

  void _finishTimer(Habit habit) {
    final state = _getState(habit);

    _tickers[habit]?.cancel();

    _tickers.remove(habit);

    state.endTime = null;

    state.pausedRemainingSeconds = 0;

    state.isRunning = false;

    state.isSessionCompleted = true;

    // ----------------------------------------------------------
    // UPDATE HABIT PROGRESS
    // ----------------------------------------------------------

    _updateHabitProgress(habit);

    // ----------------------------------------------------------
    // COMPLETE DAILY GOAL
    // ----------------------------------------------------------

    if (habit.progress >= habit.goal) {
      HabitStore.instance.completeHabitForToday(
        habit,
      );
    }

    // ----------------------------------------------------------
    // NOTIFICATION
    // ----------------------------------------------------------

    NotificationService
        .showTimerCompletedNotification(
      habitId: habit.id,
      habitTitle: habit.title,
    );

    // ----------------------------------------------------------
    // UPDATE DETAIL SCREEN
    // ----------------------------------------------------------

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // UPDATE HABIT PROGRESS
  // ------------------------------------------------------------

  void _updateHabitProgress(Habit habit) {
    int progressToAdd;

    // ----------------------------------------------------------
    // MINUTE-BASED HABIT
    // ----------------------------------------------------------

    if (habit.unit.toLowerCase() ==
        'minutes') {
      progressToAdd =
          habit.timerMinutes;
    }

    // ----------------------------------------------------------
    // COUNT-BASED HABIT
    // ----------------------------------------------------------

    else {
      progressToAdd = 1;
    }

    habit.progress += progressToAdd;

    // ----------------------------------------------------------
    // KEEP PROGRESS INSIDE GOAL
    // ----------------------------------------------------------

    if (habit.progress >= habit.goal) {
      habit.progress = habit.goal;
    }

    // ----------------------------------------------------------
    // DO NOT AWARD XP HERE
    //
    // HabitStore is responsible for completion + XP.
    // ----------------------------------------------------------
  }

  // ------------------------------------------------------------
  // CONTINUE TO NEXT UNIT
  // ------------------------------------------------------------

  void continueToNextUnit(
    Habit habit,
  ) {
    final state = _getState(habit);

    if (habit.progress >= habit.goal) {
      return;
    }

    state.endTime = null;

    state.pausedRemainingSeconds = 0;

    state.isSessionCompleted = false;

    state.isRunning = false;

    HabitStore.instance.clearLastAwardedXp();

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // CLEAR SPECIFIC HABIT
  // ------------------------------------------------------------

  void clear(Habit habit) {
    _tickers[habit]?.cancel();

    _tickers.remove(habit);

    _timers.remove(habit);

    _notifyListeners();
  }

  // ------------------------------------------------------------
  // CLEAR ALL TIMERS
  // ------------------------------------------------------------

  void clearAll() {
    for (final timer in _tickers.values) {
      timer.cancel();
    }

    _tickers.clear();

    _timers.clear();

    HabitStore.instance.clearLastAwardedXp();

    _notifyListeners();
  }
}

