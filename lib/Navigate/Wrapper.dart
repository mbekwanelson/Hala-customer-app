import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Authenticate/Authenticate.dart';
import 'package:mymenu/Authenticate/VerificationEmail.dart';
import 'package:mymenu/Home/Options.dart';
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
    dynamic user = Provider.of<User>(context); // acessing user data from
    Auth().user;

    // if it returns a user that means that that user is signed in (registered)
    try {
      user.reload().then((value) {});
      if (user == null) {
        // user not signed in
        return Authenticate();
      } else if (user.isEmailVerified == false) {
        return VerificationEmail();
      } else {
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
      return Authenticate();
    }
  }
}
