import 'package:flutter/material.dart';
import 'package:login_app/Screen/Welcome/components/background.dart';
import 'package:login_app/Screen/Welcome/components/teddy.dart';

class Body extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Background(
      children: Column(
          children: <Widget>[
            Expanded(child: TeddyFlare())
          ],
      )
    );
  }
}


