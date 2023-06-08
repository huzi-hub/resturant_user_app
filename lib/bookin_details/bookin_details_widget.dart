import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserApp extends StatefulWidget {
  @override
  _UserAppState createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    // Initialize the local notification plugin
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initLocalNotifications();
  }

  // Initialize the local notification settings
  Future<void> _initLocalNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Handle the "book now" button click
  void _handleBookNowButton() async {
    final int notificationId = 0;
    final String notificationTitle = 'Table booking request';
    final String notificationBody = 'I want to book a table';
    final String notificationPayload = 'user_booking_request';

    // Show the local notification to the restaurant app
    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          
          priority: Priority.high,
          importance: Importance.high,
          ticker: 'ticker',
        ),
      ),
      payload: notificationPayload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User App'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Book Now'),
          onPressed: _handleBookNowButton,
        ),
      ),
    );
  }
}
