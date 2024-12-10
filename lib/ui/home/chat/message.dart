import 'package:cloud_firestore/cloud_firestore.dart';

/// A class to represent a message in a chat room.
/// This class is used to store messages in Firestore.
class Message {
  final String senderID;
  //final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    //required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  //convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      //'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}