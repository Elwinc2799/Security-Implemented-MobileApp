import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;

  const RoundedButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width * 0.7,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                backgroundColor: MaterialStateProperty.all(kPrimaryColour),
              ),
              onPressed: press,
              child: Text(
                  text,
                  style: TextStyle(
                    color: kPrimaryLightColour,
                    fontFamily: "Comfortaa",
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  )
              ),
            )
        )
    );
  }
}