import 'package:flutter/material.dart';
import 'package:yiddishconnect/ui/home/friend/friendFunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<FriendRequest> notifications = [];
  final String currentUserId = AuthService.getCurrentUserId();
  late Stream<QuerySnapshot> _notificationStream;

  @override
  void initState() {
    super.initState();
    _notificationStream = FirebaseFirestore.instance
        .collection('friendRequests')
        .where('receiverID', isEqualTo: currentUserId)
        .snapshots();

    _notificationStream.listen((snapshot) {
      setState(() {
        notifications = snapshot.docs.map((doc) {
          return FriendRequest(
            senderId: doc['senderID'],
            receiverId: doc['receiverID'],
            time: _formatTimestamp(doc['timestamp'].toDate()),
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            await _acceptFriendRequest(index);
                            setState(() {
                              notifications.removeAt(index);
                            });
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
                            await _declineFriendRequest(index);
                            setState(() {
                              notifications.removeAt(index);
                            });
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
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
  }

  Future<void> _acceptFriendRequest(int index) async {
    final friendRequest = notifications[index];
    await FriendService().acceptFriendRequest(friendRequest.senderId, friendRequest.receiverId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accepted ${friendRequest.senderId}')),
    );
  }

  Future<void> _declineFriendRequest(int index) async {
    final friendRequest = notifications[index];
    await FriendService().rejectFriendRequest(friendRequest.senderId, friendRequest.receiverId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined ${friendRequest.senderId}')),
    );
  }
}

class FriendRequest {
  final String senderId;
  final String receiverId;
  final String time;

  FriendRequest({required this.senderId, required this.receiverId, required this.time});
}