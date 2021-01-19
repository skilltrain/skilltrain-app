import '../../services/cognito/authentication_services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../utils/sliders.dart';
import '../../main_app/trainee/home_page_trainee.dart';

class Rating extends StatefulWidget {
  final instructorName;
  Rating({this.instructorName});

  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<Rating> {
  int index;
  final _authService = AuthService();

  void getUrl() async {
    try {
      GetUrlResult result = await Amplify.Storage.getUrl(key: "myKey");
      print(result.url);
    } catch (e) {
      print(e.toString());
    }
  }

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
      final avgScore = totalRating / numberOfRatings;
      final req = {
        "numberOfRatings": numberOfRatings,
        "totalRating": totalRating,
        "avgScore": avgScore
      };

      final putResponse =
          await http.put(url, body: json.encode(req), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (putResponse.statusCode == 200) {
      } else {
        throw Exception('Failed to load API params');
      }
      return decoded["avgRating"];
    } else {
      throw Exception('Failed to load API params');
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(
            child: Container(
          width: double.infinity,
          child: Column(children: <Widget>[
            new Spacer(),
            Container(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Column(children: <Widget>[
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(
                      15.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple[500], width: 3),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: [
                        Text(widget.instructorName),
                        Text(
                          "How was the today's lesson?",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  print("reputation score 1 is sent");
                                  postTrainerScore(1);
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee(
                                            shouldLogOut: _authService.logOut)),
                                      ));
                                },
                                child: Text(
                                  "🙁",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  print("reputation score 2 is sent");
                                  postTrainerScore(2);
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee(
                                            shouldLogOut: _authService.logOut)),
                                      ));
                                },
                                child: Text("😑",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ))),
                            InkWell(
                                onTap: () {
                                  print("reputation score 3 is sent");
                                  postTrainerScore(3);
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee(
                                            shouldLogOut: _authService.logOut)),
                                      ));
                                },
                                child: Text("😐",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ))),
                            InkWell(
                                onTap: () {
                                  print("reputation score 4 is sent");
                                  postTrainerScore(4);
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee(
                                            shouldLogOut: _authService.logOut)),
                                      ));
                                },
                                child: Text("🙂",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ))),
                            InkWell(
                                onTap: () {
                                  print("reputation score 5 is sent");
                                  postTrainerScore(5);
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee(
                                            shouldLogOut: _authService.logOut)),
                                      ));
                                },
                                child: Text("😀",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])),
            new Spacer(),
          ]),
        )));
  }

  Future<http.Response> putTrainerScore() {
    String url =
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/" +
            widget.instructorName;
    return http.put(
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
//   Future<http.Response> updateTrainer() {
//     return http.put(
//       "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$_user",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'bio': _bio,
//         'price': _price,
//         'genre': _genre,
//       }),
//     );
//   }
// }