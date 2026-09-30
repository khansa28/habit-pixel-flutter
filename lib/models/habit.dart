
class Habit {
  // ------------------------------------------------------------
  // UNIQUE ID
  // ------------------------------------------------------------

  String id;

  // ------------------------------------------------------------
  // BASIC HABIT INFORMATION
  // ------------------------------------------------------------

  String title;

  String subtitle;

  // ------------------------------------------------------------
  // GAMIFICATION / PROGRESS
  // ------------------------------------------------------------

  int streak;

  int goal;

  int progress;

  String unit;

  int timerMinutes;

  bool completed;

  // ------------------------------------------------------------
  // XP
  // ------------------------------------------------------------

  int xp;

  // ------------------------------------------------------------
  // STREAK TRACKING
  // ------------------------------------------------------------

  DateTime? lastCompletedDate;

  DateTime? lastActivityDate;

  DateTime? lastXpDate;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  Habit({
    String? id,

    required this.title,

    required this.subtitle,

    this.streak = 0,

    this.goal = 1,

    this.progress = 0,

    this.unit = 'times',

    this.timerMinutes = 25,

    this.completed = false,

    this.xp = 0,

    this.lastCompletedDate,

    this.lastActivityDate,

    this.lastXpDate,
  }) : id =
            id ??
            DateTime.now()
                .microsecondsSinceEpoch
                .toString();


  factory Habit.fromJson(Map<String, dynamic> json) {
  return Habit(
    id: json['id'] as String?,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    streak: json['streak'] as int? ?? 0,
    goal: json['goal'] as int? ?? 1,
    progress: json['progress'] as int? ?? 0,
    unit: json['unit'] as String? ?? 'times',
    timerMinutes: json['timerMinutes'] as int? ?? 25,
    completed: json['completed'] as bool? ?? false,
    xp: json['xp'] as int? ?? 0,
    lastCompletedDate: json['lastCompletedDate'] != null
        ? DateTime.parse(json['lastCompletedDate'])
        : null,
    lastActivityDate: json['lastActivityDate'] != null
        ? DateTime.parse(json['lastActivityDate'])
        : null,
    lastXpDate: json['lastXpDate'] != null
        ? DateTime.parse(json['lastXpDate'])
        : null,
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'streak': streak,
    'goal': goal,
    'progress': progress,
    'unit': unit,
    'timerMinutes': timerMinutes,
    'completed': completed,
    'xp': xp,
    'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    'lastActivityDate': lastActivityDate?.toIso8601String(),
    'lastXpDate': lastXpDate?.toIso8601String(),
  };
}          
}

