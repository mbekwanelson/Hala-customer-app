import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:mymenu/Models/User.dart';
import 'package:mymenu/Models/http_exception.dart';

class AuthService {
  final _auth.FirebaseAuth _firebaseAuth = _auth.FirebaseAuth.instance;

  CustomUser? _userFromFirebase(_auth.User? user) {
    if (user == null) {
      return null;
    }

    return CustomUser(userId: user.uid);
  }

  Stream<CustomUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<CustomUser?> signInAnnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();

      return _userFromFirebase(credential.user);
    } on _auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "auth/email-already-exists":
          print('Failed with error code: ${e.code}');
          print(e.message);
          break;
        default:
          print("Default case");
          print('Failed with error code: ${e.code}');
          print(e.message);
      }
    }
  }

  Future<CustomUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<CustomUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    } on _auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed": //Indicates that Anonymous accounts are not enabled.
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
        case "weak-password": //If the password is not strong enough.
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
        case "invalid-email": //If the email address is malformed.
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
        case "email-already-exists": //If the email is already in use by a different account.
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
        case "invalid-credential": //If the [email] address is malformed.
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
        default:
          print("Default case");
          print('Failed with error code: ${e.code}');
          print(e.message);
          throw HttpException(e.message);
      }
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
