import 'package:flutter/material.dart';
import '../../components/tools/AnimateClass.dart';
import '../../components/tools/NotificationClass.dart';
import 'dart:async';
import '../../../Controller/Controller.dart';
import '../../../Model/Language.dart' as globals;
import 'dart:developer';

class RobotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RobotPage();
  }
}

class _RobotPage extends State<RobotPage> {
  var data;
  var items;
  var notif;
  bool loading = true;
  bool _timeout = false;
  int _value = 0;
  Timer timer;
  var colorBattery;
  var colorReservoir;
  TextEditingController editingController = TextEditingController();
  Controller controller = new Controller();
  NotificationClass notification = new NotificationClass();

  void gettrobotinfo() async {
    try {
      if (this.mounted) {
        var result = await controller.model.db.getrobot();

        setState(() {
          data = result;
          if (loading) {
            notif = new List<dynamic>();
            notif.addAll(data);
            items = new List<dynamic>();
            items.addAll(data);
          }

          var arrayBattery = new List(data.length);
          var arrayReservoir = new List(data.length);
          for (var i = 0; i < data.length; i++) {
            var valeur = data[i];

            if (valeur["battery"] > 60) {
              notif[i] = valeur;
              arrayBattery[i] = Colors.green.shade500;
            } else if (valeur["battery"] > 30) {
              arrayBattery[i] = Colors.orange.shade500;
              notif[i] = valeur;
            } else {
              arrayBattery[i] = Colors.red.shade500;
              if (!(notif[i]["battery"] <= 30))
                notification.showNotification(
                    "robot " + data[i]["robot_id"].toString(), "battery");
              notif[i] = valeur;
            }

            items[i] = valeur;

            /*valeur = data[i];
            if (valeur["reservoir"] > 60) {
              arrayReservoir[i] = Colors.red.shade500;
              if (!(notif[i]["reservoir"] >= 60))
                notification.showNotification(data[i]["name"], "reservoir");
              notif[i] = valeur;
            } else if (valeur["reservoir"] > 30) {
              arrayReservoir[i] = Colors.orange.shade500;
              notif[i] = valeur;
            } else {
              arrayReservoir[i] = Colors.green.shade500;
              notif[i] = valeur;
            }
            items[i] = valeur;*/
          }
          colorBattery = arrayBattery;
          //colorReservoir = arrayReservoir;

          loading = false;
        });
      }
    } catch (_) {
      if (this.mounted) {
        setState(() {
          _timeout = true;
        });
      }
    }
  }

  void robotChange(name, action) async {
    try {
      int nb = 1;
      switch (action) {
        case "Nettoyage":
          nb = 7;
          break;
        case "Rentrer":
          nb = 1;
          break;
        case "Stop":
          nb = 5;
          break;
      }

      var result =
          await controller.model.db.addRobotOrder("robot_order", name, nb);
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

  Widget _showMyDialog() {
    return new Scaffold(
      body: AlertDialog(
        title: Text(globals.langue[41], style: TextStyle(fontSize: 19.48)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Wrap(
                spacing: 8.0,
                children: [
                  Icon(Icons.warning_amber_rounded),
                  Text(globals.langue[42]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(data);
    if (query.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        var str = "robot " + item["robot_id"].toString();
        if (str.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(data);
      });
    }
  }

  Widget robotpage() {
    if (_timeout) {
      return _showMyDialog();
    } else if (loading)
      return AnimateClass();
    else
      return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                hintText: globals.langue[43],
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
              ),
            ),
            //Text("Liste des machines", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            for (var i = 0; i < items.length; i++)
              Card(
                elevation: 10,
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.grey.shade200,
                          title:
                              Text("robot " + items[i]["robot_id"].toString()),
                          leading: Icon(Icons.android_outlined),
                          trailing: new DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: [
                                  DropdownMenuItem(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        robotChange(
                                            items[i]["robot_id"].toString(),
                                            globals.langue[44]);
                                      },
                                      child: Align(
                                        alignment: Alignment
                                            .center, // Align however you like (i.e .centerRight, centerLeft)
                                        child: Text(globals.langue[44]),
                                      ),
                                    ),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        robotChange(
                                            items[i]["robot_id"].toString(),
                                            globals.langue[45]);
                                      },
                                      child: Align(
                                        alignment: Alignment
                                            .center, // Align however you like (i.e .centerRight, centerLeft)
                                        child: Text(globals.langue[45]),
                                      ),
                                    ),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        robotChange(
                                            items[i]["robot_id"].toString(),
                                            globals.langue[46]);
                                      },
                                      child: Align(
                                        alignment: Alignment
                                            .center, // Align however you like (i.e .centerRight, centerLeft)
                                        child: Text(globals.langue[46]),
                                      ),
                                    ),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  if (this.mounted) {
                                    setState(() {
                                      _value = value;
                                    });
                                  }
                                }),
                          ),
                        ),
                        Column(children: [
                          Wrap(
                            spacing: 8.0,
                            children: [
                              /*Chip(
                                backgroundColor: Colors.green.shade500,
                                elevation: 4,
                                avatar: Icon(Icons.add_location_alt_outlined),
                                label: Text(items[i]["position"],
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6))),
                              ),*/
                              Chip(
                                backgroundColor: colorBattery[i],
                                elevation: 4,
                                avatar: Icon(Icons.battery_charging_full),
                                label: Text(
                                    items[i]["battery"].toString() + " %",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6))),
                              ),
                              Chip(
                                backgroundColor: Colors.white,
                                elevation: 4,
                                avatar: Icon(Icons.date_range),
                                label: Text(
                                    items[i]["date"]
                                        .toString()
                                        .substring(0, 19),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6))),
                              )
                              /*Chip(
                                backgroundColor: colorReservoir[i],
                                elevation: 4,
                                avatar: Icon(Icons.delete_forever),
                                label: Text(items[i]["reservoir"] + " %",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6))),
                              ),*/
                            ],
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: robotpage()),
    );
  }
}
