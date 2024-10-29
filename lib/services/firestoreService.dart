import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';

/// A service class to handle Firestore operations related to user documents.
class FirestoreService {
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a user document in Firestore if it does not already exist.
  ///
  /// \param userId The unique identifier of the user.
  Future<void> createUserDocument(String userId) async {
    // Reference to the user document in the 'users' collection
    DocumentReference userDocRef = _firestore.collection('users').doc(userId);

    // Check if the document exists
    DocumentSnapshot docSnapshot = await userDocRef.get();
    if (!docSnapshot.exists && !AuthService().isAnonymous()) {
      // Create the document if it does not exist
      await userDocRef.set({
        'userId': userId, // Add user ID as a field
        'friends': [], // Initialize an empty friends array
      });
    }
  }
}