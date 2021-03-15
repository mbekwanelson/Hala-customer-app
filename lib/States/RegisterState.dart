//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/User.dart';

class RegisterState with ChangeNotifier {
  bool loading = false;
  final _formKey = GlobalKey<
      FormState>(); // will allow us to validate our form make sure the user doesnt f up
  String error = "";
  //Auth _auth; //will change later
  String email = "";
  String password = "";
  bool isEmailVerified =false;
  String emailConfirmation = "";
  final FirebaseAuth _auth= FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController passwordOriginal = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController emailValue = TextEditingController();


  //GETTERS
  GlobalKey<FormState> get formKey => _formKey;

  //Auth get auth => _auth;

  RegisterState() {

  }

  // Ensures that user types in correct email
  String validateEmail(String email) {
    if (email.isEmpty) {
      //user didn't enter email

      notifyListeners();
      return "Enter email";
    }
    //user entered email correctly
    notifyListeners();
    return null;
  }

  String validateName(String name) {
    if (name.isEmpty) {
      //user didn't enter email

      notifyListeners();
      return "Enter Name";
    }
    //user entered email correctly
    notifyListeners();
    return null;
  }

  String validateSurname(String surname) {
    if (surname.isEmpty) {
      //user didn't enter email

      notifyListeners();
      return "Enter Surname";
    }
    //user entered email correctly
    notifyListeners();
    return null;
  }

  // ensures user types correct password
  String validatePassword(String password) {
    if (password.length < 6) {
      //user didn't enter valid password

      notifyListeners();
      return "Enter password 6 characters long";
    }
    notifyListeners();
    //user entered valid password
    return null;
  }

  // ensures user types correct password
  String confirmPassword(String password) {
    if (password != passwordOriginal.text) {
      //user didn't enter valid password

      notifyListeners();
      return "Passwords do not match!";
    }
    notifyListeners();
    //user entered valid password
    return null;
  }

  // once register button is clicked

  registerClicked() async {
    if (_formKey.currentState.validate()) {
      // if the form is valid

      loading = true;

      dynamic result = await registerWithEmailAndPassword(
          email, password); //used dynamic because could either get user or null
      if (result == null) {
        loading = false;
        //error = "please supply a valid email";
      }

    }
    notifyListeners();
  }



  // Returns user object which contains firebaseID
  User _userFromFireBaseUser(FirebaseUser user){
    return user!=null ? User(userId: user.uid) : null;
  }

  // registers new user
  Future registerWithEmailAndPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //grab user from that result
      FirebaseUser fb_user  = result.user;

      if(fb_user !=null){
        await fb_user.sendEmailVerification().then((value){
          print("__________________Is email verified: ${fb_user.isEmailVerified}");

        });
        // loads user data to database every time new user registers
        String uid = await Auth().inputData();
        await Firestore.instance.collection("Users").document(uid).setData({


          "name":name.text,
          "surname":surname.text,
          "email":email,
          "user":"Customer",
          "date":DateTime.now()

        });
        //await Future.delayed(const Duration(seconds: 1), () => "1");
      }



      print("Is email verified: ${fb_user.isEmailVerified}");




      //create a new document for user with uid
      return fb_user.isEmailVerified ? _userFromFireBaseUser(fb_user): null;
      // will only work if it was succesful ie can sign in with email and password
    }
    catch(e){
      print(e);
      switch (e.code) {

        case "ERROR_EMAIL_ALREADY_IN_USE":
          error = "Email already registered, sign in.";
          break;

        case "ERROR_INVALID_EMAIL":
          error = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          error = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          error= "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          error = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          error = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          error = "Signing in with Email and Password is not enabled.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          error = "Please check your internet connection";
          break;


        default:
          error = "An undefined Error happened.";
      }
      notifyListeners();
      print("could not create user");
      return null;

    }
  }

}
