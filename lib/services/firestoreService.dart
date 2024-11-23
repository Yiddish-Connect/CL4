import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:universal_io/io.dart';
/// A service class to handle Firestore operations related to user documents.
class FirestoreService {
  String userId = AuthService.getCurrentUserId();
  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a user document in Firestore if it does not already exist.
  ///
  /// \param userId The unique identifier of the user.
  Future<void> createUserDocument(String userId, String displayName) async {
    // Reference to the user document in the 'users' collection
    DocumentReference userDocRef = _firestore.collection('users').doc(userId);

    // Check if the document exists
    DocumentSnapshot docSnapshot = await userDocRef.get();
    if (!docSnapshot.exists && !AuthService().isAnonymous()) {
      // Create the document if it does not exist
      await userDocRef.set({
        'displayName': displayName, // Add display name as a field
        'userId': userId, // Add user ID as a field
        'friends': [], // Initialize an empty friends array
        //android notification token
        'androidNotificationTokens': [],
        //ios notification token
        'iosNotificationTokens': [],
        //web notification token
        'webNotificationTokens': [],
      });
    }
  }


  Future<void> addToken(String token) async {
    print("addToken $token");
    DocumentReference userDocRef = _firestore.collection('users').doc(userId);
    String platform = getPlatform();
    print ("platform $platform");
    if (platform == 'android') {
      await userDocRef.update({
        'androidNotificationTokens': FieldValue.arrayUnion([token]),
      });
    } else if (platform == 'ios') {
      await userDocRef.update({
        'iosNotificationTokens': FieldValue.arrayUnion([token]),
      });
    } else if (platform == 'web') {
      await userDocRef.update({
        'webNotificationTokens': FieldValue.arrayUnion([token]),
      });
    }
  }

  String getPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (kIsWeb) {
      return 'web';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }
}