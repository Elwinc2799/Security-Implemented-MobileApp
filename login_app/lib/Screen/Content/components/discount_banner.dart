import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          width:  size.width,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF4A3298),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Text.rich(
                TextSpan(
                  text: "A Summer Surprise\n",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  children: [
                    TextSpan(
                      text: "Cashback 20%",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                  ]
                ),
              ),
            ],
          )
        ),
      ]
    );
  }
}