import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingPage {
  rateApp(BuildContext context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'expiryreminder',
      minDays: 0,
      minLaunches: 0,
      remindDays: 0,
      remindLaunches: 0,
      googlePlayIdentifier: 'com.aswdc_ExpiryReminder&hl=en&gl=US',
      appStoreIdentifier: ' ',
    );

    rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      message:
          'Do You like this app ?\nThen take a little bit of your time to leave a rating:',
      actionsBuilder: (context, stars) {
        return [
          // Return a list of actions (that will be shown at the bottom of the dialog).
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              if (stars! < 3) {
                Navigator.of(context).pop();
              } else {
                launchUrl(Uri.parse(
                    "https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder&pcampaignid=web_share"));
              }
              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(
                  context, RateMyAppDialogButton.rate);
            },
          ),
        ];
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: const StarRatingOptions(),
      onDismissed: () =>
          rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  }
}
