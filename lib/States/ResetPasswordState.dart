
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordState with ChangeNotifier{
  TextEditingController email = TextEditingController();
  final FirebaseAuth _auth= FirebaseAuth.instance;


  ResetPasswordState(){

  }

  @override
  Future<void> resetPassword() async {
    await _auth.sendPasswordResetEmail(email: email.text);
  }


}