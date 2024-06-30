import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcq/models/chat.dart';
import 'package:hcq/models/message.dart';
import 'package:hcq/models/post.dart';
import 'package:hcq/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove(
              [uid],
            ),
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion(
              [uid],
            ),
          },
        );
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Like comment
  Future<void> likeComment(String postId, String commentId, String uid) async {
    try {
      final DocumentReference commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);

      final DocumentSnapshot commentSnapshot = await commentRef.get();

      if (commentSnapshot.exists) {
        final Map<String, dynamic>? data =
            commentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          List<String> likedBy = List<String>.from(data['likedBy'] ?? []);

          if (likedBy.contains(uid)) {
            await commentRef.update({
              'likes': FieldValue.arrayRemove([uid]),
              'likedBy': FieldValue.arrayRemove([uid]),
            });
          } else {
            await commentRef.update({
              'likes': FieldValue.arrayUnion([uid]),
              'likedBy': FieldValue.arrayUnion([uid]),
            });
          }
        } else {
          // print('Comment data is null');
        }
      } else {
        // print('Comment document does not exist');
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      // print(e.toString());
    }
  }

  // follow users
  // follow users
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  // Create chat
  Future<String> createChat(String uid1, String uid2) async {
    String res = "some error occurred";
    try {
      String chatId = const Uuid().v1();
      Chat chat = Chat(
        chatId: chatId,
        users: [uid1, uid2],
        lastMessageTime: DateTime.now(),
      );

      await _firestore.collection('chats').doc(chatId).set(chat.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Send message
  Future<String> sendMessage(
      String chatId, String senderId, String text, bool isUser) async {
    String res = "some error occurred";
    try {
      String messageId = const Uuid().v1();
      Message message = Message(
        messageId: messageId,
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
        isUser: isUser,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessageTime': DateTime.now(),
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Get chat messages
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  // Get user chats
  Stream<List<Chat>> getUserChats(String uid) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList());
  }

  // Store user's chat with chatbot
  Future<String> storeUserChatWithChatbot(
      String uid, List<Message> messages) async {
    String res = "Some error occurred";
    try {
      String chatId = uid; // Use user's UID as chat ID for simplicity

      for (Message message in messages) {
        await _firestore
            .collection('chatbot_chats')
            .doc(chatId)
            .collection('messages')
            .doc(message.messageId)
            .set(message.toJson());
      }

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Load chat with chatbot for current user
  Stream<List<Message>> loadChatWithChatbot(String uid) {
    String chatId = uid; // Use user's UID as chat ID for simplicity
    return _firestore
        .collection('chatbot_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  // Method to delete chat with chatbot
  Future<void> deleteChatWithChatbot(String uid) async {
    try {
      CollectionReference messagesRef = _firestore
          .collection('chatbot_chats')
          .doc(uid)
          .collection('messages');

      QuerySnapshot snapshot = await messagesRef.get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // print('User messages deleted!');
    } catch (e) {
      // print('Error deleting chat: $e');
    }
  }
}
