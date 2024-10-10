import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'chat.dart';

class ChatHomepage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {'username': 'Leo', 'lastMessage': ''},
    {'username': 'Alan', 'lastMessage': ''},
    // Add more chats here
  ];

  @override
  Widget build(BuildContext context) {
    // Sort chats alphabetically by username
    chats.sort((a, b) => a['username']!.compareTo(b['username']!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatUser: chats[index]['username']!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(chats[index]['username']!),
                        subtitle: Text(chats[index]['lastMessage']!),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}