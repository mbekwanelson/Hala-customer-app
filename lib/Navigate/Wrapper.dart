import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Authenticate/Authenticate.dart';
import 'package:mymenu/Authenticate/VerificationEmail.dart';
import 'package:mymenu/Home/Options.dart';
import 'package:mymenu/Models/User.dart';

import 'package:mymenu/States/OptionsState.dart';
import 'package:mymenu/States/UserDrawerState.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    print("Wrapper build");
    var user = Provider.of<fbauth.User>(
        context); // acessing user data from Auth().user;
    print("user: $user");

    // if it returns a user that means that that user is signed in (registered)
    try {
      print("trying to reload user");
      // user.reload().then((value) {});
      if (user == null) {
        print("User is null showing signin page");

        // user not signed in
        return Authenticate();
      } else if (user.emailVerified == false) {
        print(
            "user is logged in but email is not verified : loading email verification screen");

        return VerificationEmail();
      } else {
        print("User signed in : ${user.email}");
        // Bastard signed in!
        return MultiProvider(
          providers: [
            // StreamProvider.value(
            // value: RestaurantState().numberRestaurants()
            // ),
            ChangeNotifierProvider.value(value: UserDrawerState()),
            ChangeNotifierProvider.value(value: OptionsState()),
            StreamProvider.value(value: OptionsState().getOptions()),
          ],
          child: Options(),
        );
      }
    } catch (e) {
      print("an error ocured: ");
      print(e);
      return Authenticate();
    }
  }
}
