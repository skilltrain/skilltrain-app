import 'package:flutter/material.dart';
import './booking_page.dart';
import '../../../utils/sliders.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(data["profilePhoto"]),
              Row(children: <Widget>[
                Text(data["instructor"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
              ]),
              Text(
                data["bio"],
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: BookingPage(
                      price: data["price"],
                      trainerName: data["username"],
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
        ));
  }
}
