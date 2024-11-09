import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/services/firebaseAuthentication.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NotificationProvider extends ChangeNotifier {
  List<FriendRequest> notifications = [];
  final String currentUserId = AuthService.getCurrentUserId();
  late StreamSubscription<QuerySnapshot> _notificationSubscription;

  NotificationProvider() {
    _notificationSubscription = FirebaseFirestore.instance
        .collection('friendRequests')
        .where('receiverID', isEqualTo: currentUserId)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((doc) {
        return FriendRequest(
          senderId: doc['senderID'],
          receiverId: doc['receiverID'],
          time: _formatTimestamp(doc['timestamp'].toDate()),
        );
      }).toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
  }
}

class FriendRequest {
  final String senderId;
  final String receiverId;
  final String time;

  FriendRequest({required this.senderId, required this.receiverId, required this.time});
}