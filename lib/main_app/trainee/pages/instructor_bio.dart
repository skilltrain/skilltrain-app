import 'package:flutter/material.dart';
import './booking_page.dart';
import '../../../utils/sliders.dart';

class InstructorBio extends StatelessWidget {
  final Map data;
  final index;
  InstructorBio({this.data, this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (var i = 0; i < data["avgRating"]; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow[700], size: 14));

      if (i == data["avgRating"].round() - 1) {
        print("number of ratings");
        stars.add(Text("(" + data["numberOfRatings"].toString() + ")",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 10,
            )));
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(data["firstName"] + " " + data["lastName"]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(data["profilePhoto"]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  Text(data["firstName"] + " " + data["lastName"],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )),
                  Spacer(),
                  Row(
                    children: stars,
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data["bio"],
                  style: TextStyle(
                    fontSize: 15,
                  ),
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
                  padding: EdgeInsets.all(10),
                  child: Text('check availability now! >>>',
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
