import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import './../../amplifyconfiguration.dart';

class InstructorBioUpdate extends StatefulWidget {
  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<InstructorBioUpdate> {
  int index;

  String _uploadFileResult = '';
  String _getUrlResult = '';
  String _removeResult = '';

  void _upload() async {
    try {
      File local = await FilePicker.getFile(type: FileType.image);
      final key = new DateTime.now().toString();
      Map<String, String> metadata = <String, String>{};
      metadata['type'] = 'testPhoto';
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

  void getUrl() async {}

  void _download() async {}

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
                          onPressed: _upload,
                          child: const Text('Upload Image'),
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
                      children: <Widget>[
                        Image.asset('assets/images/bio.png',
                            height: 150, fit: BoxFit.fill),
                        Text(
                          "Upload classPhoto",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'genre'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'price'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'bio',
                    ),
                    maxLines: 4,
                    minLines: 4,
                  ),
                ])),
            RaisedButton(
              onPressed: () {},
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
                child: const Text('Uodate profile',
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
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  String _text = '';

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text(
              "$_text",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
            new TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines: 1,
              //パスワード
              onChanged: _handleText,
            ),
          ],
        ));
  }
}
