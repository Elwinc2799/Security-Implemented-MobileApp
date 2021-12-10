import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;

  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? 'Don\'t have an account?' : 'Already have an account?',
          style: TextStyle(
            color: kPrimaryColour,
            fontFamily: 'Comfortaa',
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? ' Sign Up' : ' Sign In',
            style: TextStyle(
              color: kPrimaryColour,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comfortaa',
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}