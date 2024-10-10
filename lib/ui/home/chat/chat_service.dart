import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Define the currentUser variable
  final ChatUser currentUser = ChatUser(
    id: '12',
    firstName: 'Bie',
    lastName: '',
  );

  //function to generate a chat room id
  String generateChatRoomId(String userId, String receiverId) {
    List<String> roomId = [userId, receiverId];
    roomId.sort();
    return roomId.join('_');
  }
  Stream<List<ChatMessage>> getMessages(String userId, String receiverId) {
    // Build a chat room id for the two users
    String chatRoomId = generateChatRoomId(userId, receiverId);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return ChatMessage(
          text: data['message'],
          user: data['senderID'] == currentUser.id ? currentUser : ChatUser(id: data['senderID']),
          createdAt: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }


  Future<void> sendMessage(String message, receiverId) async {
    final timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderID: currentUser.id,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );
    //make a chatroom id by softing the user id to make it unique
    String chatRoomId = generateChatRoomId(currentUser.id, receiverId);
    try {
      //check if the chat room exists
      DocumentSnapshot chatRoomSnapshot = await _firestore.collection('chat_rooms').doc(chatRoomId).get();
      if (!chatRoomSnapshot.exists) {
        //create a new chat room
        await _firestore.collection('chat_rooms').doc(chatRoomId).set({});
      }
      await _firestore.collection('chat_rooms').doc(chatRoomId)
          .collection('chats').add(newMessage.toMap());
      print('Message sent successfully');
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}