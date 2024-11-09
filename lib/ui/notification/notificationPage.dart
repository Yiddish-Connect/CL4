import 'package:flutter/material.dart';
import 'package:yiddishconnect/ui/home/friend/friendFunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/notification/notificationProvider.dart';

/// A page to display the user's notifications.
/// This page displays a list of the user's notifications.
/// The user can accept or decline friend requests.
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = notificationProvider.notifications;
        return notifications.isEmpty
            ? Center(child: Text("Don't have any notifications yet"))
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(item.senderId)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return ListTile(
                    title: Text('Loading...'),
                    subtitle: Text(item.time),
                  );
                }

                final senderName = userSnapshot.data!['displayName'];
                return ListTile(
                  title: Text(senderName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.time),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await _acceptFriendRequest(context, index);
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await _declineFriendRequest(context, index);
                              },
                              child: Text(
                                'Decline',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _acceptFriendRequest(BuildContext context, int index) async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final friendRequest = notificationProvider.notifications[index];
    await FriendService().acceptFriendRequest(friendRequest.senderId, friendRequest.receiverId);
    notificationProvider.notifications.removeAt(index);
    notificationProvider.notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accepted ${friendRequest.senderId}')),
    );
  }

  Future<void> _declineFriendRequest(BuildContext context, int index) async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final friendRequest = notificationProvider.notifications[index];
    await FriendService().rejectFriendRequest(friendRequest.senderId, friendRequest.receiverId);
    notificationProvider.notifications.removeAt(index);
    notificationProvider.notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined ${friendRequest.senderId}')),
    );
  }
}
