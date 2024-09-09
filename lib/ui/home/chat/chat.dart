import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatUser;

  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatUser currentUser;
  late ChatUser otherUser;
  late List<ChatMessage> messages;

 @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
      id: '1',
      firstName: 'Jichun',
      lastName: 'Q',
      
    );

    otherUser = ChatUser(
      id: '2',
      firstName: 'Alan',
      lastName: 'Turing',
      customProperties: {'avatar': 'https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg'},
    );

    messages = <ChatMessage>[
      ChatMessage(
        text: 'Hey!',
        user: otherUser, // The message is from the other user
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: otherUser.customProperties?['avatar'] != null
              ? NetworkImage(otherUser.customProperties!['avatar']!)
              : null,
          child: otherUser.customProperties?['avatar'] == null
              ? Icon(Icons.person)
              : null,
        ),

        title: Text("${otherUser.firstName} ${otherUser.lastName}"),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Container(
        color: Colors.white, // Set the background color here
        child: DashChat(
          currentUser: currentUser,
          onSend: (ChatMessage m) {
            setState(() {
              messages.insert(0, m);
            });
          },


          messages: messages,
        ),
      ),
    );
  }
}
