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
  // String _platformVersion = 'Unknown';
  //
  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  //   AdvancedInAppReview()
  //       .setMinDaysBeforeRemind(7)
  //       .setMinDaysAfterInstall(0)
  //       .setMinLaunchTimes(2)
  //       .setMinSecondsBeforeShowDialog(4)
  //       .monitor();
  // }
  //
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     platformVersion = await AdvancedInAppReview.platformVersion ??
  //         'Unknown platform version';
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

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
