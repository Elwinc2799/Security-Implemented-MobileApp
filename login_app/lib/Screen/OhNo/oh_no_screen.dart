import 'package:flutter/material.dart';
import 'package:login_app/logging.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  var log = getLogger('SomethingWentWrongScreen');
  @override
  Widget build(BuildContext context) {
    // set logger here error 404
    log.e("Error Occured");
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/ohno.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.15,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            right: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Color(0xFF70DAAD),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {},
              child: Text(
                "Try Again".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}