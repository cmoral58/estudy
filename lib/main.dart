import 'package:estudy/pages/Login/login.dart';
import 'package:estudy/pages/formal/search_book_page_formal.dart';
import 'package:estudy/pages/formal/stamp_collection_page_formal.dart';
import 'package:estudy/pages/home/home_page.dart';
import 'package:estudy/pages/material/search_book_page_material.dart';
import 'package:estudy/pages/material/stamp_collection_page_material.dart';
import 'package:estudy/pages/notes/notes_page.dart';
import 'package:estudy/pages/universal/collection_page.dart';
import 'package:estudy/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()
      // MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Studily',
      //   home: LoginPage(),
      // ),
      );
}

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new HomePage(),
  '/notes': (BuildContext context) => new NotesPage(),
  // '/': (BuildContext context) => new WelcomeScreen(),
  // '/': (Builder context) => new LoggedIn(),
  '/search_material': (BuildContext context) => new SearchBookPage(),
  '/search_formal': (BuildContext context) => new SearchBookPageNew(),
  '/collection': (BuildContext context) => new CollectionPage(),
  '/stamp_collection_material': (BuildContext context) =>
      new StampCollectionPage(),
  '/stamp_collection_formal': (BuildContext context) =>
      new StampCollectionFormalPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Studily',
      home: WelcomeScreen(),
      // navigatorKey: locator<NavigationService>().navigatorKey,
      // onGenerateRoute: (routeSettings) {
      //   switch (routeSettings.name) {
      //     case 'notes':
      //       return MaterialPageRoute(builder: (context) => NotesPage());
      //     default:
      //       return MaterialPageRoute(builder: (context) => HomePage());
      //   }
      // },
      routes: routes,
    );
  }
}
