import 'package:flutter/material.dart';

class SpecialForYou extends StatelessWidget {
  final String image;
  final String category;
  final String quantity;

  const SpecialForYou({
    Key key,
    @required this.image,
    @required this.category,
    @required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: size.height * 0.15,
        width: size.width * 0.6,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF343434).withOpacity(0.4),
                            Color(0xFF343434).withOpacity(0.15),
                          ]
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text.rich(
                      TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: category + "\n",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            TextSpan(
                              text: quantity,
                            )
                          ]
                      )
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}