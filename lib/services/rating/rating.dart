import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/sliders.dart';
import '../../main_app/trainee/home_page_trainee.dart';

class Rating extends StatefulWidget {
  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<Rating> {
  int index;
  // pic urls
  String _uploadProfilePicFileResult = '';
  String _uploadClassFileResult = '';

  //Text field state
  String _genre = "";
  String _price = "";
  String _bio = "";
  //Current User

  String _user = "";
  void _getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      _user = res.username;
      getTrainerData();
    } on AuthError catch (e) {
      print(e);
    }
  }

  void _uploadProfilePic() async {
    try {
      File local = await FilePicker.getFile(type: FileType.image);
      var key = new DateTime.now().millisecondsSinceEpoch.toString();
      key = "images/trainers/$_user/profilePhoto/" + key;
      Map<String, String> metadata = <String, String>{};
      metadata['type'] = 'profilePhoto';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadProfilePicFileResult = result.key;
      });
      print(_uploadProfilePicFileResult);
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  void _uploadSessionPhoto() async {
    try {
      File local = await FilePicker.getFile(type: FileType.image);
      var key = new DateTime.now().millisecondsSinceEpoch.toString();
      key = "images/trainers/$_user/sessionPhoto/" + key;
      Map<String, String> metadata = <String, String>{};
      metadata['type'] = 'sessionPhoto';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadClassFileResult = result.key;
      });
      print(_uploadClassFileResult);
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  void getUrl() async {
    try {
      GetUrlResult result = await Amplify.Storage.getUrl(key: "myKey");
      print(result.url);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<dynamic, dynamic>> getTrainerData() async {
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$_user');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      setState(() {
        _bio = res["bio"];
        _genre = res["genre"];
        _price = res["price"];
      });

      return res;
    } else {
      throw Exception('Failed to load API params');
    }
  }

  void initState() {
    super.initState();
    _getCurrentUser();
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
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee()),
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
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee()),
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
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee()),
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
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee()),
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
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: (HomePageTrainee()),
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

  Future<http.Response> updateTrainer() {
    return http.put(
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$_user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'bio': _bio,
        'price': _price,
        'genre': _genre,
      }),
    );
  }
}
