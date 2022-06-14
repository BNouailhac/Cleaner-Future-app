import 'package:flutter/material.dart';
import '../../View/pages/navbar_view/MapPage.dart';
import '../../View/pages/navbar_view/RobotPage.dart';
import '../../View/pages/navbar_view/HomePage.dart';

class Navigatorbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Navigatorbar();
  }
}

class _Navigatorbar extends State<Navigatorbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [HomePage(), MapPage(), RobotPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade500,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          new BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'MAP'),
          new BottomNavigationBarItem(
              icon: Icon(Icons.android_outlined), label: 'Robot')
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
