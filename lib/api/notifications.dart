import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tzone;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveBackgroundNotification(
      NotificationResponse notificationResponse) async {}

  static Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/launcher_icon');
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iOSInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotification,
      onDidReceiveNotificationResponse: onDidReceiveBackgroundNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> scheduleReminderNotifications({
    required String productName,
    required DateTime reminderDate,
    required String reminderTime,
    required String operation,
    required int id,
  }) async {
    List<String> timeParts = reminderTime.split(":");
    final scheduledDate = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      print("Scheduled date must be in the future.");
      return;
    }

    print("Scheduling notification for: $reminderDate for id: $id");

    if (operation == "update") {
      print("Cancel existing notification for id $id");
      await cancelNotification(id);
    }

    await _scheduleNotification(
      id: id,
      title:
          'Attention: ${productName[0].toUpperCase() + productName.substring(1)} Expiration Alert',
      body:
          'Heads up! Your $productName will expire on ${scheduledDate.toString().split(" ")[0]}.',
      scheduledDate: scheduledDate,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    tzone.TZDateTime timeToset =
        tzone.TZDateTime.from(scheduledDate, tzone.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      timeToset,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
