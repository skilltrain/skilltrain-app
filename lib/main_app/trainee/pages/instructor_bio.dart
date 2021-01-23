import 'package:flutter/material.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import './booking_page.dart';
import '../../../utils/sliders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
      stars.add(Icon(Icons.star, color: Colors.cyanAccent, size: 14));

      if (i == widget.data["avgRating"].round()) {
        print("number of ratings");
        stars.add(Text("(" + widget.data["numberOfRatings"].toString() + ")",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 10,
            )));
      }
    }
    return Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
          title: Text(widget.data["firstName"] + " " + widget.data["lastName"]),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 36),
                child: Text("Say Hello to",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 36)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36, bottom: 36),
                child: Text(widget.data["firstName"] + "!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 36)),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8)),
                      color: Colors.white),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 36),
                      child: SizedBox(
                        height: 150,
                        child: Hero(
                          tag: widget.index,
                          child: Material(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        blackHeading(
                                            title: widget.data["firstName"],
                                            underline: false,
                                            purple: false),
                                        Row(
                                          children: stars,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(widget.data["genre"]),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              "¥" +
                                                  widget.data["price"]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ]),
                                  Column(children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          widget.data["profilePhoto"],
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ])
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Text(widget.data["bio"]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: cyanButton(
                        text: "Book Now",
                        function: () {
                          Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: BookingPage(
                                    price: widget.data["price"],
                                    trainerName: widget.data["username"],
                                    index: widget.index,
                                    genre: widget.data["genre"])),
                          );
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 36.0, top: 24),
                          child: blackHeading(
                              title: "Reviews", underline: true, purple: true),
                        )),
                    FutureBuilder(
                      future: reviews,
                      builder: (context, snapshot) {
                        if (snapshot.data != null && snapshot.data.length > 0) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 36),
                            child: Container(
                              height: 150,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  // shrinkWrap: true,
                                  // physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    DateTime date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data[index]["timestamp"]);
                                    var format = new DateFormat("yMd");
                                    var dateString = format.format(date);

                                    List<Widget> stars = [];

                                    for (var i = 0;
                                        i < snapshot.data[index]["rating"];
                                        i++) {
                                      stars.add(Icon(Icons.star,
                                          color: Colors.cyanAccent, size: 12));
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Card(
                                            child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0, top: 16),
                                                  child: Text(
                                                      snapshot.data[index][
                                                              "user_username"] +
                                                          " - ",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: stars,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  '"' +
                                                      snapshot.data[index]
                                                          ["review"] +
                                                      '"',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(dateString),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                    );
                                  }),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.waiting ??
                            snapshot.connectionState ==
                                ConnectionState.active) {
                          Container(
                              height: MediaQuery.of(context).size.height - 87,
                              decoration: new BoxDecoration(
                                  color: Colors.deepPurple[100]),
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        return Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: Text(
                                    "It looks like this trainer has no reviews!"),
                              ),
                            ],
                          ),
                        ));
                      },
                    )
                  ])),
            ],
          ),
        ));
  }
}
