import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        messageId: json['messageId'],
        senderId: json['senderId'],
        text: json['text'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
      );
}
