import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcq/models/user.dart' as model;
import 'package:hcq/resources/storage_methods.dart';

class AuthMethods {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    firebase_auth.User currentUser = _auth.currentUser!;

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

        // Send email verification
        await cred.user!.sendEmailVerification();

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

  // New method to send verification code
  Future<String> sendVerificationCode({required String email}) async {
    String res = "Some error occurred!";
    try {
      String code = generateVerificationCode();
      await _firestore
          .collection('verificationCodes')
          .doc(email)
          .set({'code': code});

      // Send email with the verification code
      // Use your preferred email sending service here
      await sendEmail(email, code);

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // New method to verify code
  Future<String> verifyCode(
      {required String email, required String code}) async {
    String res = "Some error occurred!";
    try {
      DocumentSnapshot snap =
          await _firestore.collection('verificationCodes').doc(email).get();

      if (snap.exists && snap['code'] == code) {
        res = 'success';
      } else {
        res = 'Invalid verification code';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Helper method to generate a verification code
  String generateVerificationCode() {
    final Random random = Random();
    const int codeLength = 6;
    String code = '';
    for (int i = 0; i < codeLength; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  // Placeholder method for sending email
  Future<void> sendEmail(String email, String code) async {
    // Implement your email sending logic here
  }
}
