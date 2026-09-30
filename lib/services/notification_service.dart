import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Stores the habit ID from the notification that was tapped.
  static String? pendingHabitId;

  // ------------------------------------------------------------
  // LISTENERS
  // ------------------------------------------------------------

  static final List<void Function()> _listeners = [];

  static void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  static void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  // ------------------------------------------------------------
  // INITIALIZE NOTIFICATIONS
  // ------------------------------------------------------------

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse:
          _onNotificationTapped,
    );
print('NOTIFICATION_TRACE: plugin initialize END');



  }

  // ------------------------------------------------------------
  // NOTIFICATION TAP
  // ------------------------------------------------------------

  static void _onNotificationTapped(
    NotificationResponse response,
  ) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    pendingHabitId = payload;

    // Tell the app that a notification was tapped.
    _notifyListeners();
  }

  // ------------------------------------------------------------
  // SHOW TIMER COMPLETED NOTIFICATION
  // ------------------------------------------------------------

  static Future<void> showTimerCompletedNotification({
    required String habitId,
    required String habitTitle,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'habit_timer_channel',
      'Habit Timer',
      channelDescription:
          'Notifications for completed HabitPixel timers',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      habitId.hashCode,
      '⏰ Timer Complete!',
      '$habitTitle session is complete. Great job! 🎉',
      notificationDetails,
      payload: habitId,
    );
  }

  // ------------------------------------------------------------
  // GET PENDING HABIT
  // ------------------------------------------------------------

  static String? consumePendingHabitId() {
    final habitId = pendingHabitId;

    pendingHabitId = null;

    return habitId;
  }
}