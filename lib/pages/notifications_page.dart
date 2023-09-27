import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    'You have a new message from John Doe.',
    'Your booking for tomorrow has been confirmed.',
    'Today is a special event! Join now.',
    // Add more notification messages here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Handle notification item tap (e.g., navigate to a detailed notification view)
            },
          );
        },
      ),
    );
  }
}
