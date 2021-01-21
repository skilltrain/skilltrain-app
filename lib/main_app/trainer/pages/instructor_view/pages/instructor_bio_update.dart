import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstructorBioUpdate extends StatefulWidget {
  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<InstructorBioUpdate> {
  int index;
  // pic urls
  //Leave this here I will use later
  // ignore: unused_field
  String _uploadProfilePicFileResult = '';
  String _uploadClassFileResult = '';

  //Text field state
  String _genre;
  int _price;
  String _bio;
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
          title: Text("Update Your Bio"),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Column(children: <Widget>[
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(
                      5.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple[500], width: 3),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        InkWell(
                          onTap:(){
                            _uploadProfilePic();
                          },
                          child: Column(
                            children: [Image.asset('assets/images/bio.png',
                                        height: 150, fit: BoxFit.fill),
                                      ])
                        ),
                        Text("Upload profile photo")
                        /*
                        RaisedButton(
                          onPressed: _uploadProfilePic,
                          child: const Text('Upload Profile Pic'),
                        ),
                        */
                      ],
                    ),
                    // child: Column(
                    //   children: <Widget>[
                    //     Image.asset('assets/images/bio.png',
                    //         height: 150, fit: BoxFit.fill),
                    //     Text(
                    //       "Upload portrait",
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 20,
                    //           color: Colors.black54),
                    //     )
                    //   ],
                    // ),
                  ),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(
                      5.0,
                    ),
                    margin: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple[500], width: 3),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: [

                        InkWell(
                          onTap:(){
                            _uploadSessionPhoto();
                          },
                          child: Column(
                            children: [Image.asset('assets/images/bio.png',
                                        height: 150, fit: BoxFit.fill),
                                      ])
                        ),
                        Text("Upload Session Photo")

                      /*
                        RaisedButton(
                          onPressed: _uploadSessionPhoto,
                          child: const Text('Upload Session Photo'),
                        ),
                        */
                      ],
                    ),
                  ),
                  TextFormField(
                      controller: TextEditingController(text: _genre),
                      decoration: InputDecoration(labelText: 'genre'),
                      onChanged: (text) => _genre = text),
                  TextFormField(
                      // keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: _price != null ? _price.toString() : ""),
                      decoration: InputDecoration(labelText: 'price'),
                      onChanged: (text) => _price = int.parse(text)),
                  TextFormField(
                      controller: TextEditingController(text: _bio),
                      decoration: InputDecoration(
                        labelText: 'bio',
                      ),
                      maxLines: 4,
                      minLines: 4,
                      onChanged: (text) => _bio = text),
                ])),
            RaisedButton(
              onPressed: () async {
                final dynamic result = await updateTrainer();
                if(result.statusCode == 201 || result.statusCode == 200){
                  print("update successful");
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("Instructor bios successfully updated"),
                        children: <Widget>[
                          // コンテンツ領域
                          SimpleDialogOption(
                            onPressed: () => Navigator.pop(context),
                            child: Text(""),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print("update unsuccesful");
                }
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
                child: const Text('Update profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
              ),
            ),
          ]),
        )));
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
