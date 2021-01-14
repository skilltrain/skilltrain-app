import 'package:flutter/material.dart';
import './booking_page.dart';

//Page transition animation from left to right
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

//Page transition animation from left to right
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class InstructorBio extends StatelessWidget {
  final Map data;
  final index;
  InstructorBio({this.data, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("instructor bios"),
      ),
      body: Column(
        children: <Widget>[
          Image.network(data["profilePhoto"]),
          Row(children: <Widget>[
            Text(data["instructor"],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
            new Spacer(),
          ]),
          Text(
            data["bio"],
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          new Spacer(),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                SlideLeftRoute(
                    page: Booking(
                  index: index,
                )),
              );
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.pink[300],
                    Colors.purple[500],
                    Colors.purple[700],
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: const Text('check availability now! >>>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
