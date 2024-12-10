import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/ui/home/chat/chat_service.dart';

/// A service class to handle friend-related operations in Firestore.
/// This class is responsible for sending, accepting, and rejecting friend requests,
class FriendService {
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a friend request from the sender to the receiver.
  ///
  /// \param senderId The unique identifier of the sender.
  /// \param receiverId The unique identifier of the receiver.
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    String requestId = '$senderId\_$receiverId';
    await _firestore
        .collection('friendRequests')
        .doc(requestId)
        .set({
      'senderID': senderId, // ID of the user sending the request
      'receiverID': receiverId, // ID of the user receiving the request
      'timestamp': FieldValue.serverTimestamp(), // Timestamp of the request
    });
  }

  /// Accepts a friend request and updates both users' friend lists.
  ///
  /// \param senderId The unique identifier of the sender.
  /// \param receiverId The unique identifier of the receiver.
  Future<void> acceptFriendRequest(String senderId, String receiverId) async {
    // Add sender to receiver's friend list
    await _firestore.collection('users').doc(receiverId).update({
      'friends': FieldValue.arrayUnion([senderId]),
      // Add sender ID to receiver's friends list
    });

    // Add receiver to sender's friend list
    await _firestore.collection('users').doc(senderId).update({
      'friends': FieldValue.arrayUnion([receiverId]),
      // Add receiver ID to sender's friends list
    });
    String requestId = '$senderId\_$receiverId';
    // Remove the specific friend request document
    await _firestore.collection('friendRequests').doc(requestId).delete();
  }

  /// Rejects a friend request and removes it from the database.
  ///
  /// \param senderId The unique identifier of the sender.
  /// \param receiverId The unique identifier of the receiver.
  Future<void> rejectFriendRequest(String senderId, String receiverId) async {
    String requestId = '$senderId\_$receiverId';
    // Remove the specific friend request document
    await _firestore.collection('friendRequests').doc(requestId).delete();
  }

  /// Deletes a friend from the user's friend list.
  ///
  /// \param userId The unique identifier of the user.
  /// \param friendId The unique identifier of the friend to be deleted.
  Future<void> deleteFriend(String userId, String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friends': FieldValue.arrayRemove([friendId]),
    });
    await _firestore.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayRemove([userId]),
    });
    // delete the chat room
    ChatService().deleteChatRoom(userId, friendId);
  }
}