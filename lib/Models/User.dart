import 'package:firebase_auth/firebase_auth.dart' as _auth;

class User {
  late final String userId;
  late final bool isEmailVerified;

  User({required this.userId, required this.isEmailVerified});
  User.fromFirebaseUser(_auth.User? firebaseUser) {
    this.userId = firebaseUser!.uid;
    this.isEmailVerified = firebaseUser.emailVerified;
  }

  // set userId(String uid) {
  //   this.userId = uid;
  // }
}
