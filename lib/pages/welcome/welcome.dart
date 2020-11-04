import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        alignment: Alignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Positioned(
            top: 260,
            left: 25,
            child: Text(
              "Studily",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 55,
                  color: Color(0xff6159E6)),
            ),
          ),
          Positioned(
            top: 320,
            left: 65,
            child: Text(
              "An app for students",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xff9891FF)),
            ),
          ),
          Positioned(
              bottom: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RaisedButton(
                  color: Color(0xff6159E6),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                    // Code for navigation
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 100,
            right: 0,
            child: Image.asset(
              'assets/WaveImages/WelcomeWave.PNG',
              width: size.width * 1,
            ),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Image.asset(
              'assets/WelcomeScreenImages/undraw_book_lover_mkck.png',
              width: size.width * 0.8,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
