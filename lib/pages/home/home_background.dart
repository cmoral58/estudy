import 'package:estudy/components/card_info.dart';
import 'package:estudy/pages/books/books_page.dart';
import 'package:estudy/pages/health/health_page.dart';
import 'package:estudy/pages/money/money_page.dart';
import 'package:estudy/pages/notes/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class HomePageBackground extends StatefulWidget {
  HomePageBackground({Key key}) : super(key: key);

  @override
  _HomePageBackgroundState createState() => _HomePageBackgroundState();
}

class _HomePageBackgroundState extends State<HomePageBackground> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
  }

  List<CardInfo> cardInfo = [
    CardInfo(
        card_name: 'Notes/Todos',
        card_image:
            'assets/undraw_Personal_notebook_re_d7dc-removebg-preview.png',
        card_bio: 'Add And Create Notes'),
    CardInfo(
        card_name: 'Books',
        card_image: 'assets/undraw_Bibliophile_hwqc.png',
        card_bio: 'Search for Books online'),
    CardInfo(
        card_name: 'Health Tracker',
        card_image: 'assets/undraw_healthy_habit-removebg-preview.png',
        card_bio: 'Manage Your Health'),
    CardInfo(
        card_name: 'Manage Money',
        card_image: 'assets/undraw_wallet_aym5-removebg-preview.png',
        card_bio: 'Manage Your Money'),
  ];

  // ignore: non_constant_identifier_names
  Widget PagesCardInfo(CardInfo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        padding: EdgeInsets.only(top: 8.0),
        width: 350,
        child: new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Color(0xff6159E6),
          elevation: 0,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      height: 50.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(CardInfo.card_image),
                        ),
                      ),
                    ),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        CardInfo.card_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        CardInfo.card_bio,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      // width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            // child: Image.asset('assets/WaveImages/HomeScreenBubbles.png'),
            child: Image.asset(
              'assets/WaveImages/HomeScreenWaveBubble.png',
              height: size.height * 0.8,
            ),
          ),

          // Uncomment this to show the avatar

          // Positioned(
          //   top: 50,
          //   right: 25,
          //   child: Material(
          //     borderRadius: BorderRadius.circular(500),
          //     child: InkWell(
          //       borderRadius: BorderRadius.circular(500),
          //       onTap: () {},
          //       child: CircleAvatar(
          //         radius: 70,
          //         backgroundImage: AssetImage(
          //           'assets/Studily_avatar.png',
          //         ),
          //         backgroundColor: Color(0xff6159E6),
          //       ),
          //     ),
          //   ),
          // ),

          Positioned(
            top: 75,
            left: 80,
            child: Text(
              'Studily',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          new Stack(
            children: <Widget>[
              Positioned(
                bottom: 500,
                child: new Container(
                  height: size.height * 0.15,
                  width: size.width * 1,
                  child: Stack(
                    children: <Widget>[
                      SfCalendar(
                        backgroundColor: Colors.transparent,
                        view: CalendarView.month,
                        viewHeaderStyle: ViewHeaderStyle(
                          dateTextStyle: TextStyle(
                            color: Color(0xff6159E6),
                          ),
                          dayTextStyle: TextStyle(
                            color: Color(0xff6159E6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        headerStyle: CalendarHeaderStyle(
                          textStyle: TextStyle(
                            color: Color(0xff9891FF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        monthViewSettings: MonthViewSettings(
                          agendaStyle: AgendaStyle(
                            dateTextStyle: TextStyle(
                              color: Color(0xff6159E6),
                            ),
                          ),
                          monthCellStyle: MonthCellStyle(
                            textStyle: TextStyle(
                              color: Color(0xff6159E6),
                            ),
                          ),
                          numberOfWeeksInView: 1,
                          dayFormat: 'EEE',
                          agendaViewHeight: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Center(
            child: new Container(
              width: double.infinity,
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity, // This affects the white container
                // height: size.height / 1.6,
                height: size.height / 1.7,
                // color: Colors.white,
                decoration: BoxDecoration(
                  // Box shadow for container
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.grey,
                      color: Color(0xff9891FF),
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8.0),
                                    height: 100.0,
                                    width: 350,
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      // color: Color(0xff6159E6),
                                      color: Color(0xff9891FF),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Container(
                                                height: 50.0,
                                                width: 100.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        cardInfo[0].card_image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                ),
                                                Text(
                                                  cardInfo[0].card_name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cardInfo[0].card_bio,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotesPage()),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8.0),
                                    height: 100.0,
                                    width: 350,
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Color(0xff6159E6),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Container(
                                                height: 50.0,
                                                width: 100.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: new DecorationImage(
                                                    // fit: BoxFit.cover,
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        cardInfo[1].card_image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                ),
                                                Text(
                                                  cardInfo[1].card_name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cardInfo[1].card_bio,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BooksPage()),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8.0),
                                    height: 100.0,
                                    width: 350,
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      // color: Color(0xff6159E6),
                                      color: Color(0xff9891FF),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Container(
                                                height: 50.0,
                                                width: 100.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        cardInfo[2].card_image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                ),
                                                Text(
                                                  cardInfo[2].card_name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cardInfo[2].card_bio,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HealthPage()),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8.0),
                                    height: 100.0,
                                    width: 350,
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Color(0xff6159E6),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Container(
                                                height: 50.0,
                                                width: 100.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        cardInfo[3].card_image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                ),
                                                Text(
                                                  cardInfo[3].card_name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cardInfo[3].card_bio,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoneyPage()),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
