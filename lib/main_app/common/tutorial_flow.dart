import 'package:flutter/material.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/utils/sliders.dart';

class TutorialOne extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialOne({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/tute1.gif', fit: BoxFit.fill),
              Text(
                'Find your favourite trainer!',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    height: 2.5),
              ),
              new Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cyanButton(
                    text: "Learn More",
                    function: () {
                      Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: TutorialTwo(
                            shouldShowSession: shouldShowSession,
                            firstTime: firstTime,
                          )));
                    },
                  ),
                ],
              ),
              new Spacer(),
            ])));
  }
}

class TutorialTwo extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialTwo({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/tute2.gif', fit: BoxFit.fill),
              Text(
                'Reserve a session',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    height: 2.5),
              ),
              new Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cyanButton(
                    text: "Learn More",
                    function: () {
                      Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: TutorialThree(
                            shouldShowSession: shouldShowSession,
                            firstTime: firstTime,
                          )));
                    },
                  ),
                ],
              ),
              new Spacer(),
            ])));
  }
}

class TutorialThree extends StatelessWidget {
  final VoidCallback shouldShowSession;
  final bool firstTime;

  const TutorialThree({Key key, this.shouldShowSession, this.firstTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Column(children: <Widget>[
              new Spacer(),
              Image.asset('assets/images/videoChat.gif',
                  height: 400, fit: BoxFit.fill),
              Text(
                'Train Remotely',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    height: 2.5),
              ),
              new Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cyanButton(
                    text: "Learn More",
                    function: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (firstTime) {
                        shouldShowSession();
                      }
                    },
                  ),
                ],
              ),
              new Spacer(),
            ])));
  }
}
