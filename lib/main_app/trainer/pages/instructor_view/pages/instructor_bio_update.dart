import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/common/buttons.dart';
import 'dart:convert';

import 'package:skilltrain/main_app/common/headings.dart';

class InstructorBioUpdate extends StatefulWidget {
  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<InstructorBioUpdate> {
  int index;

  //Text field state
  String _genre = "Type";
  int _price;
  String _bio;
  String _photo;

  final _priceKey = GlobalKey<FormState>();

  //Current User
  String _user = "";
  void _getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      _user = res.username;
      await getTrainerData();
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
        _photo = result.key;
      });
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
        print(result);
      });
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  getUrl(key) async {
    try {
      S3GetUrlOptions options = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.guest, expires: 30000);
      GetUrlResult result =
          await Amplify.Storage.getUrl(key: key, options: options);
      return result.url;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<dynamic, dynamic>> getTrainerData() async {
    final response = await http.get(
        'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$_user');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      String photo = await getUrl(res["profilePhoto"]);

      setState(() {
        _bio = res["bio"];
        _genre = res["genre"];
        _price = res["price"];
        _photo = photo;
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
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(36),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              blackHeading(
                                  title: "Change Your ",
                                  underline: false,
                                  purple: false),
                              blackHeading(
                                  title: "Profile",
                                  underline: true,
                                  purple: true)
                            ],
                          )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: _photo != null
                              ? DecorationImage(
                                  image: NetworkImage(_photo),
                                )
                              : null,
                        ),
                        width: 100,
                        height: 100,
                        // child: FadeInImage.assetNetwork(
                        //   placeholder: "./../../assets/icon/icon.png",
                        //   image: _photo,
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(children: [
                        cyanButton(
                            text: "Upload a Profile Photo",
                            function: () {
                              _uploadProfilePic();
                            }),
                        Container(
                          width: 100,
                          child: DropdownButton<String>(
                            hint: Text(_genre,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            isExpanded: true,
                            items: <String>[
                              'Cardio',
                              'Weights',
                              'Stretching',
                              'Yoga',
                              'Rowing',
                              'General Fitness',
                              'Running',
                              'Core',
                              'Other',
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: new Text(value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _genre = value;
                              print("Genre is" + value);
                              setState(() {
                                _genre = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Form(
                            key: _priceKey,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: _price != null
                                        ? _price.toString()
                                        : ""),
                                decoration: InputDecoration(labelText: 'Price'),
                                validator: (value) =>
                                    value == null ?? num.tryParse(value) == null
                                        ? 'Please write a number'
                                        : null,
                                onChanged: (text) => _price = int.parse(text)),
                          ),
                        ),
                        TextFormField(
                            controller: TextEditingController(text: _bio),
                            decoration: InputDecoration(
                              labelText: 'bio',
                            ),
                            maxLines: 4,
                            minLines: 4,
                            onChanged: (text) => _bio = text),
                        cyanButton(
                            text: "Update Profile",
                            function: () async {
                              if (_priceKey.currentState.validate()) {
                                final dynamic result = await updateTrainer();
                                if (result.statusCode == 201 ||
                                    result.statusCode == 200) {
                                  print("update successful");
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(
                                            "Instructor bios successfully updated"),
                                        children: <Widget>[
                                          // コンテンツ領域
                                          SimpleDialogOption(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(""),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                print("update unsuccesful");
                              }
                            })
                      ]),
                    ),
                  ),

                  // RaisedButton(
                  //   onPressed: () async {
                  //     if (_priceKey.currentState.validate()) {
                  //       final dynamic result = await updateTrainer();
                  //       if (result.statusCode == 201 ||
                  //           result.statusCode == 200) {
                  //         print("update successful");
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return SimpleDialog(
                  //               title: Text(
                  //                   "Instructor bios successfully updated"),
                  //               children: <Widget>[
                  //                 // コンテンツ領域
                  //                 SimpleDialogOption(
                  //                   onPressed: () => Navigator.pop(context),
                  //                   child: Text(""),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       }
                  //     } else {
                  //       print("update unsuccesful");
                  //     }
                  //   },
                  //   textColor: Colors.white,
                  //   padding: const EdgeInsets.all(0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: <Color>[
                  //           Colors.pink[300],
                  //           Colors.purple[500],
                  //           Colors.purple[700],
                  //         ],
                  //       ),
                  //     ),
                  //     child: const Text('Update profile',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 30,
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ]),
          ),
        ));
  }

  Future<http.Response> updateTrainer() {
    return http.put(
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/$_user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'bio': _bio,
        'price': _price,
        'genre': _genre,
      }),
    );
  }
}
