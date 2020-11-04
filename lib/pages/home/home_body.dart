import 'package:flutter/material.dart';

import 'home_background.dart';

class HomePageBody extends StatefulWidget {
  HomePageBody({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            child: HomePageBackground(),
            color: Colors.transparent,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            title: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Builder(
                builder: (context) => Ink(
                  child: Image(
                    image: AssetImage('assets/logo/studily-logo.png'),
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
          ),
        ),
        Positioned(
          top: 50,
          right: 25,
          child: Material(
            borderRadius: BorderRadius.circular(500),
            child: InkWell(
              borderRadius: BorderRadius.circular(500),
              onTap: () {},
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(
                  'assets/Studily_avatar.png',
                ),
                backgroundColor: Color(0xff6159E6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
