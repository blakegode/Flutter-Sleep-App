import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fiveguys/api/firebase_api.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = '/notification-screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool bedTimeNotification = false;
  bool technologyNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Notification Settings'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text('Bed Time Notification'),
              value: bedTimeNotification,
              onChanged: (value) {
                setState(() {
                  bedTimeNotification = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Technology Notification'),
              value: technologyNotification,
              onChanged: (value) {
                setState(() {
                  technologyNotification = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}