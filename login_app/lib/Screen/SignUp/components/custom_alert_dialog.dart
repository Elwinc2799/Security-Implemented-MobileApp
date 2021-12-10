import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';

class AdvanceCustomAlert extends StatelessWidget {
  final String text;
  final String body;

  const AdvanceCustomAlert({
    Key key,
    this.text,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              width: 450,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 70, 30, 10),
                child: Column(
                  children: [
                    Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    Text(body, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    SizedBox(height: 20,),
                    // ignore: deprecated_member_use
                    RaisedButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                      color: kPrimaryColour,
                      child: Text('Okay', style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: kPrimaryColour,
                  radius: 60,
                  child: Icon(Icons.wb_cloudy_rounded, color: kPrimaryLightColour, size: 50,),
                )
            ),
          ],
        )
    );
  }
}