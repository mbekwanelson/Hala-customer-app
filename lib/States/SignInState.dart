import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/User.dart';

class SignInState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool loading = false;
  final _formKey = GlobalKey<
      FormState>(); // will allow us to validate our form make sure the user doesnt f up
  final fbauth.FirebaseAuth _auth = fbauth.FirebaseAuth.instance;
  String error = "";
  String email = "";
  String password = "";
  //GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  SignInState();

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

  signInClicked() async {
    print("signinstate >> signinclicked");
    if (_formKey.currentState.validate()) {
      // after validating if entered correct entries
      //true:false if email and correct type password entered
      loading = true;
      print("calling sign in method with $email and $password");
      try {
        var result = await signInWithEmailAndPassword(email,
            password); //used dynamic because could either get user or null
        if (result == null) {
          print("result is null");
          //error = "Could not sign in with those credentials";
          loading = false;
        }
      } on fbauth.FirebaseAuthException catch (e) {
        print("Firebase auth exception catch: ${e.code} : ${e.message}");
      }
    }
    print("Notifying listeners");
    notifyListeners();
  }

  // Returns user object which contains firebaseID
  User _userFromFireBaseUser(fbauth.User user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    print("Signinstate >> signInWithEmailAndPassword");
    try {
      print("sending sign in request");
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("usercredential result: ${result}");
      var fb_user = result.user;
      print("user from firebase: $fb_user");

      if (fb_user.emailVerified) {
        print("email is verified: returning custom user");
        return _userFromFireBaseUser(fb_user);
      }
      print("email is not verified, notifying users and returning null");
      error = "Verify Email!";
      notifyListeners();
      return null;
    } catch (e) {
      print("catching exception:");
      print("code: ${e.code} : message : ${e.message}");
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
        case "user-not-found":
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
      print("returning null, error is : $error");
      return null;
    }
  }

  Future<fbauth.User> handleGoogleSignIn() async {
    // hold the instance of the authenticated user
    fbauth.User user;
    bool new_user = true;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = _auth.currentUser;
      await _googleSignIn.signOut();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final credential = fbauth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
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
          "name": user.displayName,
          "email": user.email,
          "user": "Customer",
          "date": DateTime.now()
        });
      }
    }
    return user;
  }

  /// This mehtod makes the real auth
  // Future firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {
  //   AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
  //   dynamic user = await _auth.signInWithCredential(credential);
  //   return user;
  // }

  // Future signInFB() async {
  //   bool new_facebook_user = true;
  //   final fbLogin = new FacebookLogin();
  //   FacebookLoginResult result = await fbLogin.logIn(["email"]);
  //   final String token = result.accessToken.token;
  //   final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  //   final profile = jsonDecode(response.body);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken facebookAccessToken = result.accessToken;
  //       await firebaseAuthWithFacebook(
  //           token: facebookAccessToken);
  //       dynamic uid = await Auth().inputData();
  //       FirebaseFirestore.instance.collection("Users").snapshots().forEach((element) {
  //         // checks if user is already on database
  //         element.documents.forEach((document) {
  //           if(uid ==document.documentID){
  //             new_facebook_user = false;
  //           }
  //         });
  //       });

  //       await Future.delayed(const Duration(seconds: 1), () => "1");
  //       if(new_facebook_user){
  //         await FirebaseFirestore.instance.collection("Users").document(uid).setData({
  //           "name":profile["name"],
  //           "email":profile["email"],
  //           "user":"Customer",
  //           "date":DateTime.now()
  //         });
  //       }
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       break;
  //     case FacebookLoginStatus.error:
  //       break;
  //   }
  //   return profile;
  // }
}
