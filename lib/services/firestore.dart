// Put firebase firestore database service here

import 'package:cloud_firestore/cloud_firestore.dart';

// https://firebase.flutter.dev/docs/firestore/usage
class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference get yiddishlandEvents => db.collection("yiddishlandEvents");

  FirestoreService._privateConstructor() {
    print("Cloud Firestore Service Initialized...");
  }

  static final FirestoreService _singleton = FirestoreService._privateConstructor();

  factory FirestoreService() {
    return _singleton;
  }
}