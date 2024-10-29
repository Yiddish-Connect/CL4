import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    await _firestore.collection('friendRequests').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(String senderId, String receiverId) async {
    // Add sender to receiver's friend list
    await _firestore.collection('users').doc(receiverId).update({
      'friends': FieldValue.arrayUnion([senderId]),
    });

    // Add receiver to sender's friend list
    await _firestore.collection('users').doc(senderId).update({
      'friends': FieldValue.arrayUnion([receiverId]),
    });

    // Remove the friend request
    var requestSnapshot = await _firestore
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get();

    for (var doc in requestSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}