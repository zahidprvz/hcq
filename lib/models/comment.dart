import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profilePic;
  final String name;
  final String uid;
  final String text;
  final String commentId;
  final DateTime datePublished;
  final List<String> likedBy; // Add this line to include likedBy field

  Comment({
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.text,
    required this.commentId,
    required this.datePublished,
    required this.likedBy, // Add this line to include likedBy field
  });

  Map<String, dynamic> toJson() => {
        'profilePic': profilePic,
        'name': name,
        'uid': uid,
        'text': text,
        'commentId': commentId,
        'datePublished': datePublished,
        'likedBy': likedBy, // Add this line to include likedBy field
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      profilePic: snapshot['profilePic'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      text: snapshot['text'],
      commentId: snapshot['commentId'],
      datePublished: (snapshot['datePublished'] as Timestamp).toDate(),
      likedBy: List<String>.from(
          snapshot['likedBy']), // Add this line to include likedBy field
    );
  }
}
