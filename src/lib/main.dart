import 'package:flutter/material.dart';
import 'dart:core';
import 'View/pages/login_page/RootPage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../Controller/Controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Login(), //Load(Key('1'),Login(), 2),
    );
  }
}

class Login extends StatelessWidget {
  // login page parameters:
  // primary swatch color
  static const primarySwatch = Colors.white;
  // button color
  static const buttonColor = Color(0xFF66BB6A);
  // app name
  static const appName = 'Cleaner Future';
  // boolean for showing home page if user unverified
  static const homePageUnverified = false;
  Controller controller = new Controller();

  final params = {
    'appName': appName,
    'primarySwatch': primarySwatch,
    'buttonColor': buttonColor,
    'homePageUnverified': homePageUnverified,
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        title: 'Cleaner Future',
        debugShowCheckedModeBanner: true,
        theme: new ThemeData(
          primaryColor: Colors.white,
        ),
        home: new RootPage(auth: controller.authentification));
  }
}
