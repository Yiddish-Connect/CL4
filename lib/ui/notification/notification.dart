import 'package:flutter/material.dart';
//modity notification ui to call friendFunction
import 'package:yiddishconnect/ui/home/friend/friendFunction.dart';

class Notification extends StatelessWidget {
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
  final List<dynamic> notifications = [
    NotificationItem(title: 'Message from John', time: '1 hour ago'),
    FriendRequest(name: 'Alice', time: '2 hours ago'),
    FriendRequest(name: 'Bob', time: '1 hour ago'),
    // Add more notifications and friend requests here
  ];

  void _acceptFriendRequest(int index) async {
    final friendRequest = notifications[index] as FriendRequest;
    String otherUserId = 'dtM39PiV6jg7tRHqYdmQPi8OcSG2';
    await FriendService().acceptFriendRequest('currentUserId', otherUserId);
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accepted ${friendRequest.name}')),
    );
  }

  void _declineFriendRequest(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined ${notifications[index].name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        if (item is NotificationItem) {
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.time),
            trailing: Icon(Icons.notifications),
          );
        } else if (item is FriendRequest) {
          return ListTile(
            title: Text(item.name),
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
                        onPressed: () => _acceptFriendRequest(index),
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
                        onPressed: () => _declineFriendRequest(index),
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
        }
        return SizedBox.shrink();
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String time;

  NotificationItem({required this.title, required this.time});
}

void showNotification(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Notification()),
  );
}

class FriendRequest {
  final String name;
  final String time;

  FriendRequest({required this.name, required this.time});
}

class FriendRequestList extends StatelessWidget {
  final List<FriendRequest> friendRequests = [
    FriendRequest(name: 'Alice', time: '2 hours ago'),
    FriendRequest(name: 'Bob', time: '1 hour ago'),
    FriendRequest(name: 'Charlie', time: '30 minutes ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(friendRequests[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(friendRequests[index].time),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Handle accept action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Accepted ${friendRequests[index].name}')),
                        );
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
                      onPressed: () {
                        // Handle decline action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Declined ${friendRequests[index].name}')),
                        );
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
  }
}