import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';

class ResetPasswordState with ChangeNotifier {
  TextEditingController email = TextEditingController();
  final fbauth.FirebaseAuth _auth = fbauth.FirebaseAuth.instance;

  ResetPasswordState() {}

  Future<void> resetPassword() async {
    await _auth.sendPasswordResetEmail(email: email.text);
  }
}
