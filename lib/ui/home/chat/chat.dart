import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'chat_service.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';

class ChatPage extends StatefulWidget {
  final String chatUser;
  final String userId;
  const ChatPage({super.key, required this.userId, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatUser currentUser;
  late ChatUser otherUser;
  final ChatService _chatService = ChatService();
  final TextEditingController _messageControler = TextEditingController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();

    String currentUserId = AuthService.getCurrentUserId();

    currentUser = ChatUser(
      id: currentUserId,
      firstName: '',
      lastName: '',
    );

    otherUser = ChatUser(
      id: widget.userId,
      firstName: widget.chatUser,
      lastName: '',
      customProperties: {'avatar': 'https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg'},
    );
    _fetchMessages();
  }

  void _fetchMessages() {
    _chatService.getMessages(currentUser.id, otherUser.id).listen((event) {
      if (mounted) {
        setState(() {
          messages = event;
        });
      }
    });
  }

  void sendMessage() async {
    if (_messageControler.text.isNotEmpty) {
      await _chatService.sendMessage(_messageControler.text, otherUser.id);
      _messageControler.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: otherUser.customProperties?['avatar'] != null
                  ? NetworkImage(otherUser.customProperties!['avatar']!)
                  : null,
              child: otherUser.customProperties?['avatar'] == null
                  ? Icon(Icons.person)
                  : null,
            ),
            SizedBox(width: 10), // Add some space between the avatar and the name
            Text("${otherUser.firstName} ${otherUser.lastName}"),
          ],
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        color: Colors.white, // Set the background color here
        child: DashChat(
          currentUser: currentUser,
          onSend: (ChatMessage m) {
            setState(() {
              messages.insert(0, m);
              _messageControler.text = m.text;
              sendMessage();
            });
          },
          messages: messages,
        ),
      ),
    );
  }
}