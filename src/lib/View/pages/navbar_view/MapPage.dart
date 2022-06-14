import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import '../../components/tools/AnimateClass.dart';
import '../../../Controller/Controller.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../../components/tools/NotificationClass.dart';
import 'package:location/location.dart';
import '../../../Model/Language.dart' as globals;

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPage();
  }
}

class _MapPage extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: MapSample()),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  _MapSample createState() => _MapSample();
}

class _MapSample extends State<MapSample> {
  var data;
  var notif;
  List<Marker> marquer;
  bool loading = true;
  bool _timeout = false;
  Timer timer;
  int _value = 0;
  BuildContext dialogContext;
  var colorBattery;
  var colorReservoir;
  Controller controller = new Controller();
  NotificationClass notification = new NotificationClass();
  LocationData location;

  void gettrobotinfo() async {
    try {
      if (this.mounted) {
        //get localposition
        Location locationdata = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await locationdata.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await locationdata.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await locationdata.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await locationdata.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }

        _locationData = await locationdata.getLocation();

        //get robot position
        var result = await controller.model.db.getrobot();
        setState(() {
          location = _locationData;
          data = result;
          if (loading) {
            notif = new List<dynamic>();
            notif.addAll(data);
          }
          _createMarker(data);
          loading = false;

          var arrayBattery = new List(data.length);
          //var arrayReservoir = new List(data.length);

          for (var i = 0; i < data.length; i++) {
            var valeur = data[i];

            if (valeur["battery"] > 60) {
              notif[i] = valeur;
              arrayBattery[i] = Colors.green.shade500;
            } else if (valeur["battery"] > 30) {
              notif[i] = valeur;
              arrayBattery[i] = Colors.orange.shade500;
            } else {
              arrayBattery[i] = Colors.red.shade500;
              if (!(notif[i]["battery"] <= 30))
                notification.showNotification(data[i]["robot_id"].toString(), "energy");
              notif[i] = valeur;
            }

            /*valeur = data[i];
            if (int.parse(data[i]["reservoir"]) > 60) {
              arrayReservoir[i] = Colors.red.shade500;
              if (!(int.parse(notif[i]["reservoir"]) >= 60))
                notification.showNotification(data[i]["name"], "reservoir");
              notif[i] = valeur;
            } else if (int.parse(data[i]["reservoir"]) > 30) {
              arrayReservoir[i] = Colors.orange.shade500;
              notif[i] = valeur;
            } else {
              arrayReservoir[i] = Colors.green.shade500;
              notif[i] = valeur;
            }*/
          }
          colorBattery = arrayBattery;
          //colorReservoir = arrayReservoir;
        });
      }
    } catch (_) /* A timeout occurred : */ {
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

  void _createMarker(data) {
    marquer = new List<Marker>();
    marquer.add(new Marker(
      width: 80.0,
      height: 80.0,
      point: latLng.LatLng(location.latitude, location.longitude),
      builder: (ctx) => GestureDetector(
        child: Column(children: [
          Text("Moi",
              style: new TextStyle(fontSize: 17.0, color: Colors.black)),
          Icon(Icons.person, color: Colors.blue, size: 60.0)
        ]),
      ),
    ));
    for (var i = 0; i < data.length; i++)
      marquer.add(new Marker(
        width: 80.0,
        height: 80.0,
        point: latLng.LatLng(
            data[i]["longitude"], data[i]["latitude"]),
        builder: (ctx) => GestureDetector(
          child: Column(children: [
            Text("robot " +data[i]["robot_id"].toString(),
                style: new TextStyle(fontSize: 17.0, color: Colors.black)),
            Icon(Icons.adb, color: Colors.green, size: 60.0)
          ]),
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  dialogContext = context;
                  return Center(
                    child: Container(
                      child: new Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ListTile(
                              tileColor: Colors.grey.shade200,
                              title: Text(
                                  "robot " + data[i]["robot_id"].toString()),
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
                                                data[i]["robot_id"].toString(), globals.langue[44]);
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
                                                data[i]["robot_id"].toString(), globals.langue[45]);
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
                                                data[i]["robot_id"].toString(), globals.langue[46]);
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
                                    avatar:
                                        Icon(Icons.add_location_alt_outlined),
                                    label: Text(data[i]["position"],
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6))),
                                  ),*/
                                  Chip(
                                    backgroundColor: colorBattery[i],
                                    elevation: 4,
                                    avatar: Icon(Icons.battery_charging_full),
                                    label: Text(data[i]["battery"].toString() + " %",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6))),
                                  ),
                                  Chip(
                                    backgroundColor: Colors.white,
                                    elevation: 4,
                                    avatar: Icon(Icons.date_range),
                                    label: Text(
                                        data[i]["date"]
                                            .toString()
                                            .substring(0, 19),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6))),
                                  )
                                  /*Chip(
                                    backgroundColor: colorReservoir[i],
                                    elevation: 4,
                                    avatar: Icon(Icons.delete_forever),
                                    label: Text(data[i]["reservoir"] + " %",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6))),
                                  ),*/
                                ],
                              ),
                            ]),
                          ],
                        ),
                      ),
                      width: 350.0,
                      height: 120.0,
                    ),
                  );
                });
          },
        ),
      ));
  }

  Widget _showMyDialog() {
    return new Scaffold(
      body: AlertDialog(
        title: Text(globals.langue[41],
            style: TextStyle(fontSize: 19.48)),
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

  @override
  Widget build(BuildContext context) {
    if (_timeout) {
      return _showMyDialog();
    } else if (loading) return AnimateClass();
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: new FlutterMap(
          options: new MapOptions(
            minZoom: 6.0,
            maxZoom: 18.4,
            center: latLng.LatLng(43.69601402155327, 7.2702484692672025),
            zoom: 17,
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(
              markers: marquer,
            ),
          ],
        ),
      ),
    );
  }
}
