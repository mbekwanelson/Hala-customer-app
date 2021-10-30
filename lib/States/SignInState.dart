// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart'; //! TODO sya : find alternative
// import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart' as _fb_auth;
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/User.dart';

class SignInState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool loading = false;
  final _formKey = GlobalKey<
      FormState>(); // will allow us to validate our form make sure the user doesnt f up
  final _fb_auth.FirebaseAuth _auth = _fb_auth.FirebaseAuth.instance;
  String error = "";
  String email = "";
  String password = "";
  //GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  SignInState();

  String? validateEmail(String email) {
    if (email.isEmpty) {
      //user didn't enter email
      notifyListeners();
      return "Enter email";
    }
    //user entered email correctly
    notifyListeners();
    return null;
  }

  // ensures user types correct password
  String? validatePassword(String password) {
    if (password.length < 6) {
      //user didn't enter valid password
      notifyListeners();
      return "Enter password 6 characters long";
    }
    notifyListeners();
    //user entered valid password
    return null;
  }

  signInClicked() async {
    if (_formKey.currentState!.validate()) {
      // after validating if entered correct entries
      //true:false if email and correct type password entered
      loading = true;
      dynamic result = await signInWithEmailAndPassword(
          email, password); //used dynamic because could either get user or null
      if (result == null) {
        //error = "Could not sign in with those credentials";
        loading = false;
      }
    }
    notifyListeners();
  }

  // Returns user object which contains firebaseID
  User? _userFromFireBaseUser(_fb_auth.User firebaseUser) {
    return firebaseUser != null ? User.fromFirebaseUser(firebaseUser) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      _fb_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _fb_auth.User? firebaseUser = result.user;
      if (firebaseUser!.emailVerified) {
        return _userFromFireBaseUser(firebaseUser);
      }
      error = "Verify Email!";
      notifyListeners();
      return null;
    } on _fb_auth.FirebaseAuthException catch (e) {
      print(e);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          error = "Email already registered, sign in.";
          break;

        case "ERROR_INVALID_EMAIL":
          error = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          error = "You have entered an incorrect password";
          break;
        case "ERROR_USER_NOT_FOUND":
          error = "User with this email doesn't exist.";
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
        case "ERROR_USER_NOT_FOUND":
          error = "There is no user record corresponding to this account";
          break;
        default:
          error = "An undefined Error happened.";
      }
    }
    // catch (e) {
    //   print(e);
    //   switch (e.code) {
    //     case "ERROR_EMAIL_ALREADY_IN_USE":
    //       error = "Email already registered, sign in.";
    //       break;

    //     case "ERROR_INVALID_EMAIL":
    //       error = "Your email address appears to be malformed.";
    //       break;
    //     case "ERROR_WRONG_PASSWORD":
    //       error = "You have entered an incorrect password";
    //       break;
    //     case "ERROR_USER_NOT_FOUND":
    //       error = "User with this email doesn't exist.";
    //       break;
    //     case "ERROR_USER_DISABLED":
    //       error = "User with this email has been disabled.";
    //       break;
    //     case "ERROR_TOO_MANY_REQUESTS":
    //       error = "Too many requests. Try again later.";
    //       break;
    //     case "ERROR_OPERATION_NOT_ALLOWED":
    //       error = "Signing in with Email and Password is not enabled.";
    //       break;
    //     case "ERROR_NETWORK_REQUEST_FAILED":
    //       error = "Please check your internet connection";
    //       break;
    //     case "ERROR_USER_NOT_FOUND":
    //       error = "There is no user record corresponding to this account";
    //       break;
    //     default:
    //       error = "An undefined Error happened.";
    //   }
    //   return null;
    // }
  }

  Future<User> handleGoogleSignIn() async {
    // hold the instance of the authenticated user
    User user;
    var tempUser;
    bool new_user = true;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = User.fromFirebaseUser(_auth.currentUser);
      await _googleSignIn.signOut();
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final _fb_auth.AuthCredential credential =
          _fb_auth.GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      tempUser = (await _auth.signInWithCredential(credential)).user;
      user = User.fromFirebaseUser(tempUser);
    }

    if (user != null) {
      dynamic uid = await Auth().inputData();
      FirebaseFirestore.instance
          .collection("Users")
          .snapshots()
          .forEach((element) {
        // checks if user is already on database
        element.docs.forEach((document) {
          if (uid == document.id) {
            new_user = false;
          }
        });
      });

      await Future.delayed(const Duration(seconds: 1), () => "1");
      if (new_user) {
        await FirebaseFirestore.instance.collection("Users").doc(uid).set({
          "name": tempUser.displayName,
          "email": tempUser.email,
          "user": "Customer",
          "date": DateTime.now()
        });
      }
    }
    return user;
  }

  //! TODO sya : facebook login code
  /// This mehtod makes the real auth
  // Future firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {
  //   AuthCredential credential =
  //       FacebookAuthProvider.credential(accessToken: token.token);
  //   dynamic user = await _auth.signInWithCredential(credential);
  //   return user;
  // }

  //! TODO sya : facebook login code
  Future signInFB() async {
    // bool new_facebook_user = true;
    // final fbLogin = new FacebookLogin();
    // FacebookLoginResult result = await fbLogin.logIn(["email"]);
    // final String token = result.accessToken.token;
    // final response = await http.get(
    //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    // final profile = jsonDecode(response.body);
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final FacebookAccessToken facebookAccessToken = result.accessToken;
    //     await firebaseAuthWithFacebook(token: facebookAccessToken);
    //     dynamic uid = await Auth().inputData();
    //     FirebaseFirestore.instance
    //         .collection("Users")
    //         .snapshots()
    //         .forEach((element) {
    //       // checks if user is already on database
    //       element.docs.forEach((document) {
    //         if (uid == document.id) {
    //           new_facebook_user = false;
    //         }
    //       });
    //     });

    //     await Future.delayed(const Duration(seconds: 1), () => "1");
    //     if (new_facebook_user) {
    //       await FirebaseFirestore.instance.collection("Users").doc(uid).set({
    //         "name": profile["name"],
    //         "email": profile["email"],
    //         "user": "Customer",
    //         "date": DateTime.now()
    //       });
    //     }
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     break;
    //   case FacebookLoginStatus.error:
    //     break;
    // }
    // return profile;
    return false;
  }
}
