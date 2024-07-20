import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingPage {
  void rateApp(BuildContext context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'expiryreminder',
      minDays: 10,
      minLaunches: 50,
      remindDays: 7,
      remindLaunches: 25,
      googlePlayIdentifier: 'com.aswdc_ExpiryReminder',
      appStoreIdentifier: 'com.example.expiryReminder',
    );

    rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      message: 'Do you like this app? Take a moment to leave a rating:',
      actionsBuilder: (context, stars) {
        return [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              // Text color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s)!');
              if (stars != null && stars <= 3) {
                rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
                Navigator.of(context).pop();
              } else {
                // StoreRedirect.redirect(
                //     androidAppId: 'com.aswdc_ExpiryReminder',
                //     iOSAppId: 'com.example.expiryReminder');
                String playStoreLink =
                    "https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder";
                launchUrl(Uri.parse(playStoreLink));
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Rate Now',
              textScaler: TextScaler.linear(1),
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
              Navigator.of(context).pop();
            },
            child: Text(
              'Maybe Later',
              textScaler: TextScaler.linear(1),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ];
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(),
      onDismissed: () =>
          rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  }
}
