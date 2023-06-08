import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class notificationwid extends StatefulWidget {
  @override
  _notificationwidState createState() => _notificationwidState();
}

class _notificationwidState extends State<notificationwid> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token-----------------------: $token');
      // Store this token to identify the user for sending messages.
    });
  }

  void sendMessage() {
    String message = _messageController.text;
    // Send the message to the restaurant app using the server key and the restaurant's FCM token.
    // Implement your logic here to send the message.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User App'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
