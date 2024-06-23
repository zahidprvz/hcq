import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcq/models/user.dart' as model;
import 'package:hcq/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required DateTime? dateOfBirth,
    required String gender,
    required String phone,
    required Uint8List? file,
    required bool userAgreementAccepted,
    required bool privacyPolicyAccepted,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          dateOfBirth != null &&
          userAgreementAccepted &&
          privacyPolicyAccepted) {
        // Registering user here
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(cred.user!.uid);

        String photoUrl = '';
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        }

        // Adding user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          dateOfBirth: dateOfBirth,
          gender: gender,
          phone: phone,
          userAgreementAccepted: userAgreementAccepted,
          privacyPolicyAccepted: privacyPolicyAccepted,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = 'success';
      } else {
        res = 'Please fill all the required fields and accept agreements';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred!";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
