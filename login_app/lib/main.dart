import 'package:flutter/material.dart';
import 'package:login_app/Screen/Welcome/welcome_screen.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/logging.dart';

void main() {
  runApp(MyApp());
}

var log = getLogger('MyApp');

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.v("Starting the Application...");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Flutter',
      theme: ThemeData(
        primaryColor: kPrimaryColour,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen()
    );
  }
}
