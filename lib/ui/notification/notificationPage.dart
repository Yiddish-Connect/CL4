import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RemoteMessage> notifications =
        context.watch<NotificationProvider>().messages;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications yet."))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final msg = notifications[index];
          final title = msg.notification?.title ?? 'No Title';
          final body = msg.notification?.body ?? 'No Body';
          final timestamp = msg.sentTime?.toLocal().toString() ?? '';

          return ListTile(
            title: Text(title),
            subtitle: Text(body),
            trailing: Text(
              timestamp,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

