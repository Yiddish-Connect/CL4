import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to handle friend-related operations in Firestore.
class FriendService {
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a friend request from the sender to the receiver.
  ///
  /// \param senderId The unique identifier of the sender.
  /// \param receiverId The unique identifier of the receiver.
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    await _firestore.collection('friendRequests').add({
      'senderId': senderId, // ID of the user sending the request
      'receiverId': receiverId, // ID of the user receiving the request
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
      'friends': FieldValue.arrayUnion([senderId]), // Add sender ID to receiver's friends list
    });

    // Add receiver to sender's friend list
    await _firestore.collection('users').doc(senderId).update({
      'friends': FieldValue.arrayUnion([receiverId]), // Add receiver ID to sender's friends list
    });

    // Remove the friend request
    var requestSnapshot = await _firestore
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId) // Filter by sender ID
        .where('receiverId', isEqualTo: receiverId) // Filter by receiver ID
        .get();

    // Delete each friend request document
    for (var doc in requestSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}