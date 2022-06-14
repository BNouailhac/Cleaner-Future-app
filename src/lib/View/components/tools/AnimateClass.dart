import 'dart:math';

import 'package:flutter/material.dart';

class AnimateClass extends StatefulWidget {
  @override
  _AnimateloadState createState() => _AnimateloadState();
}

class _AnimateloadState extends State<AnimateClass> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOn;
  final double initialRadius = 60.0;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animationRotation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));
    animationRadiusIn = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    animationRadiusOn = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.00, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if (0.75 <= controller.value && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialRadius;
        } else if (0.00 <= controller.value && controller.value <= 0.25)
          radius = animationRadiusOn.value * initialRadius;
      });
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Stack(
          children: <Widget>[
            Image(image: AssetImage("assets/csv/CleanerFutureLogo_800X800.png")),
            RotationTransition(
              turns: animationRotation,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                    child: Dot(
                      radius: 10.0,
                      color: Colors.lightGreen[400],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                    child: Dot(
                      radius: 5.0,
                      color: Colors.brown[600],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                    child: Dot(
                      radius: 10.0,
                      color: Colors.lightGreen[400],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                    child: Dot(
                      radius: 5.0,
                      color: Colors.brown[600],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                    child: Dot(
                      radius: 10.0,
                      color: Colors.lightGreen[400],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                    child: Dot(
                      radius: 5.0,
                      color: Colors.brown[600],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                    child: Dot(
                      radius: 10.0,
                      color: Colors.lightGreen[400],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                    child: Dot(
                      radius: 5.0,
                      color: Colors.brown[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
