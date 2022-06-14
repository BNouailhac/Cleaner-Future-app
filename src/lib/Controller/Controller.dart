import 'dart:core';
import '../Model/Model.dart';
import 'controllerClass/Authentication.dart';
import 'controllerClass/Navigatorbar.dart';

class Controller {
  // connection
  Authentication authentification = new Authentication();
  // NavBar
  Navigatorbar navigator = new Navigatorbar();
  // Database
  Model model = new Model();
}
