import 'package:expiry_reminder/components/add_items_provider.dart';
import 'package:expiry_reminder/components/category_provider.dart';
import 'package:expiry_reminder/database/reminder.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'api/notifications.dart';
import 'components/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyDatabase().copyPasteAssetFileToRoot();
  await MyDatabase().updateDayLeftForAllProducts();
  await NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        print("Notification permission granted.");
      } else {
        print("Notification permission denied.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddItemsProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: Sizer(builder: (context, orientation, screenType) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: "Expiry Reminder",
            home: SplashPage(),
          );
        }));
  }
}
