// import 'package:expiry_reminder/theme/theme.dart';
import 'package:expiry_reminder/components/add_items_provider.dart';
import 'package:expiry_reminder/components/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'components/splash_screen.dart';

void main() {
  // Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddItemsProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: Sizer(builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Expiry Reminder",
            home: SplashPage(),
          );
        }));
  }
}
