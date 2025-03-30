import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:go_router/go_router.dart';

class ChatHomepage extends StatefulWidget {
  const ChatHomepage({super.key}); // ✅ Required fix

  @override
  _ChatHomepageState createState() => _ChatHomepageState();
}

class _ChatHomepageState extends State<ChatHomepage> {
  final String currentUserId = AuthService.getCurrentUserId();
  late final Stream<QuerySnapshot> _chatRoomsStream;
  final Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    _chatRoomsStream = FirebaseFirestore.instance.collection('chat_rooms').snapshots();
    _fetchUserNames();
  }

  Future<void> _fetchUserNames() async {
    final chatRoomsSnapshot = await FirebaseFirestore.instance.collection('chat_rooms').get();

    final userIds = chatRoomsSnapshot.docs
        .expand((doc) => doc.id.split('_'))
        .where((id) => id != currentUserId)
        .toSet();

    for (var userId in userIds) {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        userNames[userId] = data['displayName'] ?? 'Unknown';
      } else {
        userNames[userId] = 'Unknown';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = AuthService().isAnonymous();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: isAnonymous
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to sign in to view chats'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/auth'),
              child: const Text('Sign in'),
            ),
          ],
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          final chatRooms = snapshot.data!.docs
              .where((doc) => doc.id.split('_').contains(currentUserId))
              .toList();

          if (chatRooms.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                final receiverId = chatRoom.id.split('_').firstWhere((id) => id != currentUserId);
                final receiverName = userNames[receiverId] ?? 'Unknown';

                return StreamBuilder<QuerySnapshot>(
                  stream: chatRoom.reference
                      .collection('chats')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                      return ListTile(
                        leading: CircleAvatar(child: Text(receiverName[0])), // ✅ optional enhancement
                        title: Text(receiverName),
                        subtitle: const Text('No messages yet'),
                      );
                    }

                    final docData = messageSnapshot.data!.docs.first.data();
                    if (docData is! Map<String, dynamic>) return const SizedBox();

                    final lastMessage = docData;
                    final lastMessageTimestamp = lastMessage['timestamp'] as Timestamp;

                    final isNewMessage = lastMessage['senderID'] != currentUserId &&
                        (chatRoom['lastReadTimestamps'] == null ||
                            chatRoom['lastReadTimestamps'][currentUserId] == null ||
                            lastMessageTimestamp.compareTo(
                                chatRoom['lastReadTimestamps'][currentUserId]) >
                                0);

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
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: CircleAvatar(child: Text(receiverName[0])), // ✅ enhancement
                                title: Text(
                                  receiverName,
                                  style: TextStyle(
                                    fontWeight: isNewMessage
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  lastMessage['message'] ?? '',
                                  style: TextStyle(
                                    fontWeight: isNewMessage
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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
            ),
          );
        },
      ),
    );
  }
}
