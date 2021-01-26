import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:http/http.dart' as http;
import 'package:skilltrain/main_app/common/buttons.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class InstructorBioUpdate extends StatefulWidget {
  final List<CognitoUserAttribute> userAttributes;
  const InstructorBioUpdate({Key key, this.userAttributes}) : super(key: key);

  @override
  _InstructorBioUpdateState createState() => _InstructorBioUpdateState();
}

class _InstructorBioUpdateState extends State<InstructorBioUpdate> {
  int index;
  String _genre = "Type";
  int _price;
  String _bio;
  String _photo;
  bool canUpdatePrice = false;

  final _priceKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _getCurrentUser();

    //Check if the user should have the ability to change their price
    widget.userAttributes.forEach((attribute) {
      if (attribute.getName() == 'custom:paymentSigned') {
        if (attribute.getValue() == 'true') {
          setState(() {
            canUpdatePrice = true;
          });
        }
      }
    });
  }

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
      await getUrl(result.key);
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  // ignore: unused_element
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
      setState(() {
        _photo = result.url;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
          title: Image.asset(
            'assets/icon/icon.png',
            height: 36.0,
            width: 36.0,
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
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
                                title: "Profile", underline: true, purple: true)
                          ],
                        )),
                  ],
                ),
                Container(
                    width: double.infinity,
                    child: _photo != null
                        ? ClipRRect(
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: _photo,
                                height: 150,
                                width: 150,
                                fit: BoxFit.contain),
                          )
                        : null),
                Padding(
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
                    canUpdatePrice == true
                        ? Container(
                            width: 100,
                            child: Form(
                              key: _priceKey,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                      text: _price != null
                                          ? _price.toString()
                                          : ""),
                                  decoration:
                                      InputDecoration(labelText: 'Price'),
                                  validator: (value) => value == null ??
                                          num.tryParse(value) == null
                                      ? 'Please write a number'
                                      : null,
                                  onChanged: (text) =>
                                      _price = int.parse(text)),
                            ),
                          )
                        : Container(),
                    TextFormField(
                        controller: TextEditingController(text: _bio),
                        decoration: InputDecoration(
                          labelText: 'Bio Description',
                        ),
                        maxLines: 10,
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
                                        "You have successfully updated your bio. Thank you!"),
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
                            }
                          } else {
                            print("update unsuccesful");
                          }
                        })
                  ]),
                ),
              ],
            ),
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
