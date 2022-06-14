import 'dart:core';
import 'package:mysql1/mysql1.dart';
import 'dart:developer';
import 'package:dart_ipify/dart_ipify.dart';

class MariaDB {
  var settings = new ConnectionSettings(
      host: 'XXXXXXXXXX',
      port: XXXXXXXXXX,
      user: 'XXXXXXXXXX',
      password: 'XXXXXXXXXX',
      db: 'XXXXXXXXXX');

  Future settables(tablename, target, change) async {
    var conn = await MySqlConnection.connect(settings);

    var results = await conn.query(
        'update ' + tablename + ' set status=? where name=?', [change, target]);

    await conn.close();

    return (results.toList());
  }

  Future addRobotOrder(tablename, target, change) async {
    var conn = await MySqlConnection.connect(settings);

    var results = await conn.query(
        'insert into ' +
            tablename +
            ' (robot_id, state_id, date_send) values (?, ?, ?)',
        [target, change, '2022-05-10 12:10:00.0']);

    await conn.close();

    return (results.toList());
  }

  Future addUser(email, password) async {
    settings = new ConnectionSettings(
        host: 'XXXXXXXXXX',
        port: XXXXXXXXXX,
        user: 'XXXXXXXXXX',
        password: 'XXXXXXXXXX',
        db: 'XXXXXXXXXX');
    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query(
        'insert into user (email, roles, password, is_active, phone_number, companie_id, parent_id, name, firstname, profile_picture) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          email,
          "[\"CLIENT\"]",
          password,
          1,
          60000000000,
          1,
          1,
          "Nom",
          "Prénom",
          "CleanerFuture_Cleaner_Future.png"
        ]);
    await conn.close();
    return (results.toList());
  }

  Future getrobot() async {
    settings = new ConnectionSettings(
        host: 'XXXXXXXXXX',
        port: XXXXXXXXXX,
        user: 'XXXXXXXXXX',
        password: 'XXXXXXXXXX',
        db: 'XXXXXXXXXX');

    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query(
        "SELECT * FROM position WHERE id IN (SELECT MAX(id) FROM position GROUP BY robot_id); ");

    await conn.close();
    return (results.toList());
  }

  Future gettables(tablename, target) async {
    if (tablename == "position")
      settings = new ConnectionSettings(
          host: 'XXXXXXXXXX',
          port: XXXXXXXXXX,
          user: 'XXXXXXXXXX',
          password: 'XXXXXXXXXX',
          db: 'XXXXXXXXXX');
    else {
      settings = new ConnectionSettings(
          host: 'XXXXXXXXXX',
          port: XXXXXXXXXX,
          user: 'XXXXXXXXXX',
          password: 'XXXXXXXXXX',
          db: 'XXXXXXXXXX');
    }
    var conn = await MySqlConnection.connect(settings);

    var results =
        await conn.query('SELECT ' + target + ' from ' + tablename + ';');
    await conn.close();
    return (results.toList());
  }
}
