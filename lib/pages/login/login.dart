// import 'dart:html';
import 'dart:io';

import 'package:estudy/pages/home/home_background.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _handleSignIn,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google.png"), height: 28.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 5,
                bottom: 5,
              ),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInButtonApple() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            // ignore: todo
            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
            redirectUri: Uri.parse(
              'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
            ),
          ),
          // ignore: todo
          // TODO: Remove these if you have no need for them
          nonce: 'example-nonce',
          state: 'example-state',
        );

        print(credential);

        // This is the endpoint that will convert an authorization code obtained
        // via Sign in with Apple into a session in your system
        final signInWithAppleEndpoint = Uri(
          scheme: 'https',
          host: 'flutter-sign-in-with-apple-example.glitch.me',
          path: '/sign_in_with_apple',
          queryParameters: <String, String>{
            'code': credential.authorizationCode,
            'firstName': credential.givenName,
            'lastName': credential.familyName,
            'useBundleId':
                Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
            if (credential.state != null) 'state': credential.state,
          },
        );

        final session = await http.Client().post(
          signInWithAppleEndpoint,
        );

        // If we got this far, a session based on the Apple ID credential has been created in your system,
        // and you can now set this as the app's session
        print(session);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/apple.png"), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 5,
                bottom: 5,
              ),
              child: Text(
                'Sign in with Apple',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    Size size = MediaQuery.of(context).size;
    if (_currentUser != null) {
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
                // Translucent menu item [child: Builder()]
                child: Builder(
                  builder: (context) => Ink(
                    // Uncomment this to add accessability to the drawer

                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white.withOpacity(0.8),
                        size: 25,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 0,
            ),
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120,
                  ),
                  GoogleUserCircleAvatar(identity: _currentUser),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _currentUser.displayName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(_currentUser.email),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  GestureDetector(
                    child: IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: _handleSignOut,
                    ),
                  ),
                  SizedBox(
                    height: 215,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(500),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(500),
                      splashColor: Colors.black45,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xff9891FF).withOpacity(0.6),
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xff6159E6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new SizedBox(
            height: size.height * 0.1,
          ),
          new Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 34),
          ),
          new Image.asset(
            'assets/LoginScreenImages/undraw_unlock_24mb.png',
            width: size.width * 2,
          ),
          SizedBox(
            height: size.height * 0.07,
          ),
          _signInButton(),
          SizedBox(
            height: size.height * 0.02,
          ),
          _signInButtonApple(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
