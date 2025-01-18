import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String reciverID;
  final String senderID;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.reciverID,
    required this.senderID,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "reciverID": reciverID,
      "senderID": senderID,
      "senderEmail": senderEmail,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
