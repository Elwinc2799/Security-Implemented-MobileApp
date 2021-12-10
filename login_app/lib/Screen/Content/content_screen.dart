import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/Content/components/card_scroll_widget.dart';
import 'package:login_app/Screen/Content/components/data.dart';
import 'package:login_app/Screen/Content/components/discount_banner.dart';
import 'package:login_app/Screen/Content/components/header.dart';
import 'package:login_app/Screen/Content/components/section_title.dart';
import 'package:login_app/Screen/Content/components/special_for_you.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  var currentPage = images.length - 1.0;

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: images.length - 1);
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: 20),
            DiscountBanner(),
            SizedBox(height: 30),
            SectionTitle(text: "Special For You"),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SpecialForYou(
                    image: "assets/images/banner1.png",
                    category: "Smartphone",
                    quantity: "5 brands",
                  ),
                  SpecialForYou(
                    image: "assets/images/banner2.png",
                    category: "Fashion",
                    quantity: "20 brands",
                  ),
                  SizedBox(width: 20)
                ],
              ),
            ),
            SizedBox(height: 20),
            SectionTitle(text: "Stories of The Day"),
            Stack(
              children: [
                CardScrollWidget(currentPage),
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: images.length,
                    controller: pageController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



