import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';

/// This class is used to store chat rooms in Firestore.
/// A chat room is a collection of messages between two users.
/// Each chat room has a unique identifier.
/// The chat room document contains a sub-collection of messages.
/// The chat room document also contains the last read timestamps for each user.
/// The last read timestamps are used to determine which messages are unread.
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to generate a chat room id
  String generateChatRoomId(String userId, String receiverId) {
    List<String> roomId = [userId, receiverId];
    roomId.sort();
    return roomId.join('_');
  }

  // Function to get messages from Firebase
  Stream<List<ChatMessage>> getMessages(String userId, String receiverId) {
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
          user: data['senderID'] == userId ? ChatUser(id: userId) : ChatUser(id: data['senderID']),
          createdAt: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Function to send a message to Firebase
  Future<void> sendMessage(String message, String receiverId) async {
    String userId = AuthService.getCurrentUserId();
    final timestamp = Timestamp.now();
    Message newMessage = Message(
      senderID: userId,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );
    String chatRoomId = generateChatRoomId(userId, receiverId);
    try {
      DocumentSnapshot chatRoomSnapshot = await _firestore.collection('chat_rooms').doc(chatRoomId).get();
      if (!chatRoomSnapshot.exists) {
        await _firestore.collection('chat_rooms').doc(chatRoomId).set({
          'lastReadTimestamps': {
            userId: FieldValue.serverTimestamp(),
          }
        });
      }
      await _firestore.collection('chat_rooms').doc(chatRoomId)
          .collection('chats').add(newMessage.toMap());
      print('Message sent successfully');
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Future<void> deleteChatRoom(String userId, String friendId) async {
    String chatRoomId = generateChatRoomId(userId, friendId);
    CollectionReference chatsRef = _firestore.collection('chat_rooms').doc(chatRoomId).collection('chats');

    // Delete all documents in the 'chats' sub-collection
    QuerySnapshot chatsSnapshot = await chatsRef.get();
    for (DocumentSnapshot doc in chatsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the chat room document
    await _firestore.collection('chat_rooms').doc(chatRoomId).delete();
  }
}