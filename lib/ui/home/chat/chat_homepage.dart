import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:go_router/go_router.dart';

/// A page to display the user's chats.
/// This page displays a list of the user's chats.
class ChatHomepage extends StatefulWidget {
  @override
  _ChatHomepageState createState() => _ChatHomepageState();
}

class _ChatHomepageState extends State<ChatHomepage> {
  final String currentUserId = AuthService.getCurrentUserId();
  late Stream<QuerySnapshot> _chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _chatRoomsStream = FirebaseFirestore.instance.collection('chat_rooms').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnonymous = AuthService().isAnonymous();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: isAnonymous
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You need to sign in to view chats'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/auth');
              },
              child: Text('Sign in'),
            ),
          ],
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          final chatRooms = snapshot.data!.docs.where((doc) => doc.id.split('_').contains(currentUserId)).toList();

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                var chatRoom = chatRooms[index];
                var receiverId = chatRoom.id.split('_').firstWhere((id) => id != currentUserId);

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return ListTile(
                        title: Text('Loading...'),
                        subtitle: Text('No messages yet'),
                      );
                    }

                    var receiverName = userSnapshot.data!['displayName'] ?? 'Unknown';

                    return StreamBuilder<QuerySnapshot>(
                      stream: chatRoom.reference.collection('chats').orderBy('timestamp', descending: true).limit(1).snapshots(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                          return ListTile(
                            title: Text(receiverName),
                            subtitle: Text('No messages yet'),
                          );
                        }

                        var lastMessage = messageSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                        var lastMessageTimestamp = lastMessage['timestamp'] as Timestamp;

                        bool isNewMessage = lastMessage['senderID'] != currentUserId &&
                            (chatRoom['lastReadTimestamps'] == null ||
                                chatRoom['lastReadTimestamps'][currentUserId] == null ||
                                lastMessageTimestamp.compareTo(chatRoom['lastReadTimestamps'][currentUserId]) > 0);

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        chatUser: receiverName,
                                        userId: receiverId,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      receiverName,
                                      style: TextStyle(
                                        fontWeight: isNewMessage ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    subtitle: Text(
                                      lastMessage['message'],
                                      style: TextStyle(
                                        fontWeight: isNewMessage ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}