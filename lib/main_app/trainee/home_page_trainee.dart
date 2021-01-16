import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'pages/booking_status.dart';
import './pages/instructor_bio.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';
import '../../utils/sliders.dart';

class HomePageTrainee extends StatefulWidget {
  final VoidCallback shouldLogOut;
  HomePageTrainee({Key key, this.shouldLogOut}) : super(key: key);

  @override
  SampleStart createState() => SampleStart();
}

//Fetch All Trainer Data
Future fetchTrainers() async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');

  if (response.statusCode == 200) {
    var res = await jsonDecode(response.body);
    for (var trainer in res) {
      trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
      trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
    }
    return res;
  } else {
    throw Exception('Failed to load album');
  }
}

// //Trainerlist model
// class TrainerList {
//   final List<Trainer> trainers;

//   TrainerList({this.trainers});

//   factory TrainerList.fromJson(List<dynamic> parsedJson) {
//     List<Trainer> trainers = [];
//     trainers = parsedJson.map((i) => Trainer.fromJson(i)).toList();
//     return new TrainerList(trainers: trainers);
//   }
// }

// class Trainer {
//   final String username;
//   final String bio;
//   final String genre;
//   final dynamic id;
//   final String profilePhoto;
//   final String sessionPhoto;

//   Trainer(
//       {this.username,
//       this.bio,
//       this.genre,
//       this.id,
//       this.profilePhoto,
//       this.sessionPhoto});

//   factory Trainer.fromJson(Map<String, dynamic> json) {
//     return Trainer(
//       username: json['username'],
//       bio: json['bio'],
//       genre: json['genre'],
//       id: json['id'],
//       profilePhoto: json['profilePhoto'],
//       sessionPhoto: json['sessionPhoto'],
//     );
//   }
// }
Future getUrl(url) async {
  try {
    S3GetUrlOptions options =
        S3GetUrlOptions(accessLevel: StorageAccessLevel.guest, expires: 30000);
    GetUrlResult result =
        await Amplify.Storage.getUrl(key: url, options: options);
    return result.url;
  } catch (e) {
    print(e.toString());
  }
}

class SampleStart extends State<HomePageTrainee> {
  Future trainers;
  List listOfTrainers;

  @override
  void initState() {
    super.initState();
    trainers = fetchTrainers();
    print("trainers");
  }

  @override
  Widget build(BuildContext context) {
    //Title widget for homescreen
    Widget titleSection = Container(
        margin: EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text('Welcome\nDamian!',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w800,
                        fontSize: 50)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text('Who are you\ngonna train with\ntoday?',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
                Spacer(),
                RaisedButton(
                  onPressed: () {},
                  child:
                      Text('Find your Trainer', style: TextStyle(fontSize: 15)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                )
              ],
            ),
          ],
        ));

    //Reuseable title widget
    Widget _sectionTitle({String title}) {
      return Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.symmetric(horizontal: 50),
          padding: EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 25,
                fontWeight: FontWeight.w800),
          ));
    }

    ;

    Widget trainerListView = FutureBuilder(
      future: trainers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 150,
                  child: Card(
                    child: InkWell(
                        splashColor: Colors.purple,
                        onTap: () => {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: InstructorBio(
                                        data: snapshot.data[index],
                                        index: index)),
                              )
                            },
                        child: Container(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.network(
                                      snapshot.data[index]["profilePhoto"],
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.fill),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data[index]["username"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.yellow[700],
                                              size: 7),
                                          Icon(Icons.star,
                                              color: Colors.black, size: 7),
                                          Icon(Icons.star,
                                              color: Colors.black, size: 7),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data[index]["genre"]),
                                    Text(snapshot.data[index]["price"]
                                            .toString() +
                                        'p/s')
                                  ],
                                )
                              ],
                            ))),
                  ),
                );
                // return Text(
                //   snapshot.data[index]["username"],
                //   style: TextStyle(fontSize: 50),
                // );
              },
              itemCount: snapshot.data.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );

    return MaterialApp(
      title: 'Skill train class list',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                  color: Colors.orange[50],
                  image: DecorationImage(
                      image: AssetImage("assets/images/crossfit.jpg"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              title: Text('Booking status'),
              onTap: () => {
                Navigator.push(
                  context,
                  SlideLeftRoute(page: BookingStatus()),
                )
              },
            ),
            ListTile(
              title: Text('Log out'),
              onTap: widget.shouldLogOut,
            ),
          ],
        ) // Populate the Drawer in the next step.
            ),
        appBar: AppBar(
          title: Text('skillTrain'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: titleSection),
            Container(child: _sectionTitle(title: "Top Rated")),
            Container(child: trainerListView),
            Container(child: _sectionTitle(title: "Upcoming Sessions"))
          ],
        ),
      ),
    );
  }

  // Future<List> fetchApiResults() async {
  //   final response = await http.get(
  //       'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');
  //   if (response.statusCode == 200) {
  //     var trainers = await json.decode(response.body);
  //     for (var trainer in trainers) {
  //       trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
  //       trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
  //     }
  //     return trainers;
  //   } else {
  //     throw Exception('Failed to load API params');
  //   }
  // }
}
