import 'package:flutter/material.dart';
import '../../../Controller/controllerClass/Authentication.dart';
import '../../../Controller/Controller.dart';
import '../../components/tools/AnimateClass.dart';
import 'dart:developer';
import '../../../Model/Language.dart' as globals;

class HomeLogin extends StatefulWidget {
  HomeLogin({Key key, this.auth, this.onSignedOut, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Controller controller = new Controller();
  var data;
  bool loading = true;

  @override
  initState() {
    super.initState();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(globals.langue[25]),
          content:
              new Text(globals.langue[26]),
          actions: <Widget>[
            new FlatButton(
              child: new Text(globals.langue[27]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(globals.langue[4]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(globals.langue[28]),
          content:
              new Text(globals.langue[29]),
          actions: <Widget>[
            new FlatButton(
              child: new Text(globals.langue[4]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void gettrobotinfo() async {
    if (this.mounted) {
      var result = await controller.model.db.gettables(
          "user WHERE `email` = '" + widget.userId.toString() + "'", "*");

      setState(() {
        data = result;
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() {
    try {
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    gettrobotinfo();
    if (loading) return Center(child: AnimateClass());
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Cleaner Future', style: TextStyle(color: Colors.white)),
          flexibleSpace: Image(
            image: AssetImage('assets/csv/green_background_500X666.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: controller.navigator,
        endDrawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/csv/green_background_500X666.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Image(
                    image: AssetImage(
                        "assets/csv/CleanerFutureLogo-text_1022X736.png"),
                    width: 250,
                    height: 250),
                ListTile(
                  title: Text(globals.langue[30] + data[0]["email"],
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ListTile(
                  title: Text(
                      globals.langue[31] + data[0]["name"] + ' ' + data[0]["firstname"],
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ListTile(
                  title: Text(globals.langue[32] + data[0]["phone_number"],
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 16, color: Colors.white)),
                ),
                Spacer(),
                ListTile(
                  title: Text(globals.langue[33],
                      textAlign: TextAlign.center,
                      style:
                          new TextStyle(fontSize: 28.0, color: Colors.white)),
                  onTap: _signOut,
                ),
              ],
            ),
          ),
        ));
  }
}
