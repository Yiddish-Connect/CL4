import 'package:flutter/material.dart';
import 'package:yiddishconnect/ui/home/friend/friendFunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('friendRequests').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        notifications = snapshot.data!.docs.map((doc) {
          return FriendRequest(
            senderId: doc['senderID'],
            receiverId: doc['receiverID'],
            time: doc['timestamp'].toDate().toString(),
          );
        }).toList();

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return ListTile(
              title: Text(item.senderId),
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