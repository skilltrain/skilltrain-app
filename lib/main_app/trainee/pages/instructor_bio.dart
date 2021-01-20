import 'package:flutter/material.dart';
import './booking_page.dart';
import '../../../utils/sliders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstructorBio extends StatefulWidget {
  final Map data;
  final index;
  InstructorBio({this.data, this.index});

  @override
  _InstructorBioState createState() => _InstructorBioState();
}

class _InstructorBioState extends State<InstructorBio> {
  Future<List> fetchTrainersReviews() async {
    try {
      final response = await http.get(
          'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/' +
              widget.data["username"] +
              '/reviews');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load API params');
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future reviews;
  @override
  void initState() {
    super.initState();
    print(widget.data["username"]);
    reviews = fetchTrainersReviews();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (var i = 0; i < widget.data["avgRating"]; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow[700], size: 14));

      if (i == widget.data["avgRating"].round() - 1) {
        print("number of ratings");
        stars.add(Text("(" + widget.data["numberOfRatings"].toString() + ")",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 10,
            )));
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data["firstName"] + " " + widget.data["lastName"]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(widget.data["profilePhoto"]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  Text(widget.data["firstName"] + " " + widget.data["lastName"],
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
                  widget.data["bio"],
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
                      price: widget.data["price"],
                      trainerName: widget.data["username"],
                      index: widget.index,
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
              FutureBuilder(
                future: reviews,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data.length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          List<Widget> stars = [];

                          for (var i = 0;
                              i < snapshot.data[index]["rating"];
                              i++) {
                            stars.add(Icon(Icons.star,
                                color: Colors.yellow[700], size: 12));
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      snapshot.data[index]["user_username"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: stars,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data[index]["timestamp"])
                                          .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index]["review"]),
                                ),
                              ],
                            )),
                          );
                        });
                  } else if (snapshot.connectionState ==
                          ConnectionState.waiting ??
                      snapshot.connectionState == ConnectionState.active) {
                    Container(
                        height: MediaQuery.of(context).size.height - 87,
                        decoration:
                            new BoxDecoration(color: Colors.deepPurple[100]),
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "It looks like this trainer has no reviews!"),
                        ),
                      ],
                    ),
                  ));
                },
              )
            ],
          ),
        ));
  }
}
