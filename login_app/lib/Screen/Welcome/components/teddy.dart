import 'package:flutter/material.dart';
import 'package:login_app/Screen/SignUp/signup_screen.dart';
import 'package:login_app/Screen/Welcome/components/already_have_an_account.dart';
import 'package:login_app/Screen/Welcome/components/login_form.dart';
import 'package:login_app/Screen/Welcome/components/or_divider.dart';

class TeddyFlare extends StatelessWidget {
  const TeddyFlare({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: size.height * 0.1),
          Text(
            'WELCOME TO ALTA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Comfortaa',
              fontSize: 30,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'All the best for a whole lot less.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 20,
            )
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
            child: Column(
              children: [
                LoginForm(),
                OrDivider(),
                AlreadyHaveAnAccountCheck(
                  login: true,
                  press: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.05)
        ],
      )
    );
  }
}