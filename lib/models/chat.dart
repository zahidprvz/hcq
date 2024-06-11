import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final List<String> users;
  final DateTime lastMessageTime;

  Chat({
    required this.chatId,
    required this.users,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'users': users,
        'lastMessageTime': lastMessageTime,
      };

  static Chat fromJson(Map<String, dynamic> json) => Chat(
        chatId: json['chatId'],
        users: List<String>.from(json['users']),
        lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
      );
}
