import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rating extends StatefulWidget {
  final instructorName;
  Rating({this.instructorName});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 3;
  TextEditingController reviewController = new TextEditingController();
  String username;

  Future<Map> postTrainerScore(score) async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/" +
            widget.instructorName;
    final getResponse = await http.get(url);
    if (getResponse.statusCode == 200) {
      print(getResponse);
      final decoded = json.decode(getResponse.body);
      final numberOfRatings = decoded["numberOfRatings"] + 1;
      final totalRating = decoded["totalRating"] + score;
      final avgRating = totalRating / numberOfRatings;
      final req = {
        "numberOfRatings": numberOfRatings,
        "totalRating": totalRating,
        "avgRating": avgRating
      };

      final putResponse =
          await http.put(url, body: json.encode(req), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (putResponse.statusCode == 200) {
        print("Successful");
      } else {
        throw Exception('Failed to load API params');
      }
      return decoded;
    } else {
      throw Exception('Failed to load API params');
    }
  }

  postReview() async {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/reviews/";

    var request = {
      'trainer_username': widget.instructorName,
      'user_username': username,
      'review': reviewController.text,
      'rating': rating,
    };

    final putResponse = await http.post(url, body: json.encode(request));
    if (putResponse.statusCode == 201) {
      print(putResponse);
    } else {
      throw Exception('Failed to post review');
    }
  }

  void postReviewAndRating() async {
    await postTrainerScore(rating);
    if (reviewController.text.trim().length > 0) {
      postReview();
    }
  }

  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Rate your Trainer"),
        ),
        body: Center(
            child: Container(
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Column(children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: sectionTitle(title: "How was your lesson today?")),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: reviewController,
                      maxLines: 6,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple[700], width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText:
                              'Write a review or just click submit to rate your trainer!'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => {
                            postReviewAndRating(),
                            showDialog(
                              context: context,
                              builder: (context) => new AlertDialog(
                                title: new Text(
                                    "Review for " + widget.instructorName),
                                content: Text("Thank you for your Review"),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: new Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                            Navigator.pop(context)
                          },
                      child: Text("Submit"))
                ])),
          ]),
        )));
  }
}
