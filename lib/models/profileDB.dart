import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(String userId) async {
    try {
      await _firestore.collection('profiles').doc(userId).set({
        'uid': userId,  // Store the UID in the database
        'name': 'Unknown Name',
        'imageUrls': [],
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  Future<void> updateUserProfile(String userId, {String? name, String? imageUrl}) async {
    try {
      Map<String, dynamic> updateData = {};
      
      if (name != null) {
        updateData['name'] = name;
      }
      
      if (imageUrl != null) {
        updateData['imageUrls'] = FieldValue.arrayUnion([imageUrl]);
      }
      
      if (updateData.isNotEmpty) {
        await _firestore.collection('profiles').doc(userId).update(updateData);
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> handleUserLogin(User user) async {
    String userId = user.uid;
    print("Handling user login for UID----------: $userId");
    DocumentSnapshot userDoc = await _firestore.collection('profiles').doc(userId).get();
    if (!userDoc.exists) {
      await createUserProfile(userId);
    }
  }
}

