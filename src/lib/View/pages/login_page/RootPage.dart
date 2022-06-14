import 'package:flutter/material.dart';
import 'LoginSignupPage.dart';
import '../../../Controller/controllerClass/Authentication.dart';
import '../../components/tools/AnimateClass.dart';
import 'HomeLogin.dart';
import 'dart:developer';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter/services.dart';
import '../../../Model/Language.dart' as globals;

class RootPage extends StatefulWidget {
  RootPage({this.params, this.auth});

  final BaseAuth auth;
  final Map params;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  ERROR,
  ERRORSEC,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";

  void checkSecurity() async {
    bool jailbroken;
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailbroken = true;
    }

    if (jailbroken) {
      setState(() {
        authStatus = AuthStatus.ERRORSEC;
      });
    }
  }

  _RootPageState() {
    checkSecurity();
  }

  void _onLoggedIn() {
    var valeur = widget.auth.getCurrentUser();
    _userId = valeur.toString();
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _connectionerror() {
    setState(() {
      authStatus = AuthStatus.ERROR;
      _userId = "";
    });
  }

  Widget _showMyDialog() {
    return new Scaffold(
      body: AlertDialog(
        title: Text(globals.langue[21], style: TextStyle(fontSize: 19.48)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Wrap(
                spacing: 8.0,
                children: [
                  Icon(Icons.warning_amber_rounded),
                  Text(globals.langue[22]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showSecurityDialog() {
    return new Scaffold(
      body: AlertDialog(
        title: Text(globals.langue[23], style: TextStyle(fontSize: 19.48)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Wrap(
                spacing: 8.0,
                children: [
                  Icon(Icons.warning_amber_rounded),
                  Text(globals.langue[24]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
            auth: widget.auth,
            onSignedIn: _onLoggedIn,
            connectionerror: _connectionerror);
        break;
      case AuthStatus.LOGGED_IN:
        return new HomeLogin(
            auth: widget.auth, onSignedOut: _onSignedOut, userId: _userId);
        break;
      case AuthStatus.ERROR:
        return _showMyDialog();
      case AuthStatus.ERRORSEC:
        return _showSecurityDialog();
      default:
        return Center(child: AnimateClass());
    }
  }
}
