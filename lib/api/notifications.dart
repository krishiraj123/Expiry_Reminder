// import 'dart:convert';
//
// import 'package:expiry_reminder/components/home_screen.dart';
// import 'package:expiry_reminder/database/reminder.dart';
// import 'package:expiry_reminder/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class FirebaseAPI {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notification',
//     description: "These channel is used for most important notifications",
//     importance: Importance.defaultImportance,
//   );
//
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//
//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print("Message: ${message.notification?.title}");
//     print("Message: ${message.notification?.body}");
//     print("Message: ${message.data}");
//   }
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState?.pushNamedAndRemoveUntil(
//       HomePage.route,
//       (route) => false,
//       arguments: message,
//     );
//   }
//
//   Future<void> initLocalNotifications() async {
//     const android = AndroidInitializationSettings('@drawable/launcher_icon');
//     const ios = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: android, iOS: ios);
//
//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         final payload = response.payload;
//         if (payload != null) {
//           final message = RemoteMessage.fromMap(jsonDecode(payload));
//           handleMessage(message);
//         }
//       },
//     );
//
//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }
//
//   Future<void> initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       _localNotifications.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               _androidChannel.id,
//               _androidChannel.name,
//               channelDescription: _androidChannel.description,
//               icon: "@drawable/launcher_icon",
//             ),
//           ),
//           payload: jsonEncode(message.toMap()));
//     });
//   }
//
//   Future<void> scheduleReminderNotifications() async {
//     final productsToRemind = await MyDatabase().getProductsToRemind();
//     print("Products to remind: $productsToRemind");
//
//     for (var product in productsToRemind) {
//       final reminderDate = DateTime.parse(product['reminderDate']);
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//
//       if (reminderDate.isBefore(today)) {
//         print("----------Skipping past date: $reminderDate------");
//         continue;
//       }
//
//       print("Scheduling notification for: $reminderDate");
//
//       await _scheduleNotification(
//         id: product['PID'],
//         title: 'Reminder for ${product['productName']}',
//         body: 'Your product ${product['productName']} is nearing its expiry.',
//         scheduledDate: reminderDate,
//         payload: jsonEncode(product),
//       );
//     }
//   }
//
//   Future<void> _scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     required String payload,
//   }) async {
//     const android = AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notification',
//       channelDescription: 'This channel is used for important notifications.',
//       importance: Importance.max,
//       priority: Priority.max,
//       icon: '@drawable/launcher_icon',
//     );
//
//     const ios = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       sound: 'default.wav',
//       presentSound: true,
//     );
//     const platform = NotificationDetails(android: android, iOS: ios);
//
//     await _localNotifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local).add(Duration(minutes: 1)),
//       platform,
//       payload: payload,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token: ${fCMToken}');
//     await initPushNotifications();
//     await initLocalNotifications();
//     await scheduleReminderNotifications();
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings);
    tz.initializeTimeZones();
    await initLocalNotifications();
  }

  static Future<void> scheduleReminderNotifications({
    required String productName,
    required DateTime reminderDate,
    required String reminderTime,
    required String operation,
    required int id,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int globalCounter = prefs.getInt('globalCounter') ?? 0;

    final now = DateTime.now();
    // final today = DateTime(now.year, now.month, now.day);
    List<String> timeParts = reminderTime.split(":");

    final scheduledDate = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    // if (scheduledDate.isBefore(tz.TZDateTime(
    //     tz.local, now.year, now.month, now.day, now.hour, now.minute))) {
    //   print(
    //       "Scheduled date must be in the future: $scheduledDate and current time is: ${tz
    //           .TZDateTime(tz.local, now.year, now.month, now.day, now.hour,
    //           now.minute)} ---------${scheduledDate.isBefore(
    //           tz.TZDateTime.now(tz.local))}");
    //   return;
    // }

    print(
        "Scheduled date : ${scheduledDate} and current time is: ${tz.TZDateTime(
            tz.local, now.year, now.month, now.day, now.hour,
            now.minute)} ---------${scheduledDate.isBefore(
            tz.TZDateTime.now(tz.local))}");
    print("Scheduling notification for: $reminderDate");

    print("-----go: -------------${tz.TZDateTime.parse(
        tz.local, scheduledDate.toString())}");

    if (operation == "update") {
      print("Cancel existing notification for id ${id}");
      await _notification.cancel(id);
    }

    _scheduledNotification(
      id: id,
      title:
      'Attention: ${productName[0].toUpperCase() +
          productName.substring(1, productName.length)} Expiration Alert',
      body:
      'Heads up! your ${productName}  will expire on ${scheduledDate.toString()
          .split(" ")[0]}.',
      scheduledDate: scheduledDate,
    );

    // globalCounter++;
    //
    // await prefs.setInt('globalCounter', globalCounter);
  }

  static Future<void> _scheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    tz.initializeTimeZones();
    const android = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/launcher_icon',
      styleInformation: BigTextStyleInformation(''),
    );

    const ios = DarwinNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: ios);

    await _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.parse(tz.local, scheduledDate.toString()),
      platform,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings);
    final platform = _notification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notification',
        description: "This channel is used for important notifications",
        importance: Importance.high,
      ),
    );
  }
}
