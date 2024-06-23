import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final DateTime dateOfBirth;
  final String gender;
  final String phone;
  final bool userAgreementAccepted;
  final bool privacyPolicyAccepted;
  final List<dynamic> followers;
  final List<dynamic> following;
  final String photoUrl;

  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    required this.userAgreementAccepted,
    required this.privacyPolicyAccepted,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "phone": phone,
        "userAgreementAccepted": userAgreementAccepted,
        "privacyPolicyAccepted": privacyPolicyAccepted,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      dateOfBirth: (snapshot["dateOfBirth"] as Timestamp).toDate(),
      gender: snapshot["gender"],
      phone: snapshot["phone"],
      userAgreementAccepted: snapshot["userAgreementAccepted"] ?? false,
      privacyPolicyAccepted: snapshot["privacyPolicyAccepted"] ?? false,
      followers: List.from(snapshot["followers"]),
      following: List.from(snapshot["following"]),
      photoUrl: snapshot["photoUrl"],
    );
  }
}
