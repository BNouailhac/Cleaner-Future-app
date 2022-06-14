import 'package:flutter/material.dart';
import 'dart:async';
import '../../components/tools/NotificationClass.dart';
import '../../../Controller/Controller.dart';
import '../../../Model/Language.dart' as globals;
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  Timer timer;
  var data;
  var notif;
  bool loading = true;
  bool _timeout = false;
  NotificationClass notification = new NotificationClass();
  Controller controller = new Controller();

  void gettrobotinfo() async {
    try {
      if (this.mounted) {
        var result = await controller.model.db.gettables("robots", "*");
        data = result;
        if (loading) {
          notif = new List<dynamic>();
          notif.addAll(data);
        }

        loading = false;

        for (var i = 0; i < data.length; i++) {
          var valeur = data[i];
          if (int.parse(valeur["energy"]) > 60) {
            notif[i] = valeur;
          } else if (int.parse(valeur["energy"]) > 30) {
            notif[i] = valeur;
          } else {
            if (!(int.parse(notif[i]["energy"]) <= 30))
              notification.showNotification(data[i]["name"], "energy");
            notif[i] = valeur;
          }

          valeur = data[i];
          if (int.parse(data[i]["reservoir"]) > 60) {
            if (!(int.parse(notif[i]["reservoir"]) >= 60))
              notification.showNotification(data[i]["name"], "reservoir");
            notif[i] = valeur;
          } else if (int.parse(data[i]["reservoir"]) > 30) {
            notif[i] = valeur;
          } else {
            notif[i] = valeur;
          }
        }
      }
    } catch (_) /* A timeout occurred : */ {
      if (this.mounted) {
        setState(() {
          _timeout = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    gettrobotinfo();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => gettrobotinfo());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/csv/nicebackground_700X1048.png"),
            fit: BoxFit.cover)
          ),
          child: SingleChildScrollView(
        child: Column(
             children: <Widget>[
              Image(image: AssetImage("assets/csv/CleanerFutureLogo-text_1022X736.png"), width: 230, height: 230),
              if (globals.notif[0] != "")
                for (var i = 0; i < 1; i++)
                  Card(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      
                      children: <Widget>[
                        ListTile(
                          leading: Image(
                              image: AssetImage("assets/csv/CleanerFutureLogo_800X800.png"),width: 100,height: 150),
                          title: Text(globals.notif[0], style: TextStyle(color: Colors.white)),
                          subtitle: Text(globals.notif[1],style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      );
  }
}