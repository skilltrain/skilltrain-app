import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import './../../amplifyconfiguration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstructorBioUpdate extends StatefulWidget {
  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<InstructorBioUpdate> {
  int index;
  String _uploadFileResult = '';
  String _getUrlResult = '';
  String _removeResult = '';

  void _uploadProfilePic() async {
    try {
      File local = await FilePicker.getFile(type: FileType.image);
      var key = new DateTime.now().toString();
      key = "images/trainers/damian/profilePic/" + key;
      Map<String, String> metadata = <String, String>{};
      metadata['type'] = 'profilePic';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadFileResult = result.key;
      });
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  void _uploadClassPhoto() async {
    try {
      File local = await FilePicker.getFile(type: FileType.image);
      var key = new DateTime.now().toString();
      key = "images/trainers/damian/classPhoto/" + key;
      Map<String, String> metadata = <String, String>{};
      metadata['type'] = 'classPhoto';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadFileResult = result.key;
      });
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

  void _download() async {}

  String genre = "";
  String price = "";
  String bio = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("bio update"),
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
                        RaisedButton(
                          onPressed: _uploadProfilePic,
                          child: const Text('Upload Profile Pic'),
                        ),
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
                        RaisedButton(
                          onPressed: _uploadClassPhoto,
                          child: const Text('Upload Class Photo'),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'genre'),
                      onChanged: (value) => setState(() => genre = value)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'price'),
                      onChanged: (value) => setState(() => price = value)),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'bio',
                    ),
                    maxLines: 4,
                    minLines: 4,
                    onChanged: (value) => setState(() => bio = value),
                  ),
                ])),
            RaisedButton(
              onPressed: () async {
                final dynamic result = await updateTrainer();
                result.statusCode == 201
                    ? print("update successful")
                    : print("update unsuccesful");
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
      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/damian",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'bio': bio,
        'price': price,
        'genre': genre,
      }),
    );
  }
}
