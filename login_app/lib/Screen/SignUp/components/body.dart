import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/SignUp/components/background.dart';
import 'package:login_app/Screen/SignUp/components/signup_form.dart';
import 'package:login_app/Screen/Welcome/components/already_have_an_account.dart';
import 'package:login_app/Screen/Welcome/components/or_divider.dart';
import 'package:login_app/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Background(
        children: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * 0.065),
            Text(
              'FIRST TIME IN ALTA?\n TRY SIGNING UP!',
              style: TextStyle(
                color: kPrimaryColour,
                fontWeight: FontWeight.bold,
                fontFamily: 'Comfortaa',
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
              child: SignUpForm(),
            ),
            OrDivider(),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.pop(context);
              },
            ),
          ]
        ),
      ),
    );
  }
}
