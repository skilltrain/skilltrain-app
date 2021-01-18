import 'package:flutter/material.dart';
import 'package:skilltrain/utils/overlay_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PaymentSignup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PaymentState();
  }
}

class _PaymentState extends State<PaymentSignup> {
  bool _saving = false;
  bool _finished = false;
  String _response;

  Map<String, dynamic> infoObj = {
    "individual": {
      "address_kana": {
        "city": "トウキョウ",
        "line1": "２－３９ー７",
        "line2": "イリヤ",
        "postal_code": "110-0013",
        "state": "トウキョウト",
        "town": "イリヤ"
      },
      "address_kanji": {
        "city": "東京",
        "line1": "２－３９ー７",
        "line2": "入谷",
        "postal_code": "110-0013",
        "state": "東京都",
        "town": "台東区"
      },
      "dob": {"day": "28", "month": "12", "year": "1993"},
      "email": "",
      "gender": "male",
      "first_name_kanji": "東",
      "first_name_kana": "ア",
      "last_name_kanji": "東",
      "last_name_kana": "ア",
      "phone": "+815031362394"
    },
    "external_account": {
      "account_number": "0001234",
      "routing_number": "1100000"
    },
    "username": ""
  };

  @override
  void initState() {
    super.initState();
    getTrainerEmail();
  }

  Future getTrainerEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final trainerData = await http.get(
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers?username=$username");
    final trainerDataDecoded = convert.jsonDecode(trainerData.body);
    infoObj["individual"]["email"] = trainerDataDecoded[0]['email'];
    infoObj["username"] = username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Payment sign up'),
        ),
        body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 1400,
                child: Stack(children: <Widget>[
                  OverlayText(
                      text: _saving
                          ? "Creating payment account"
                          : _finished
                              ? _response
                              : "",
                      color: Colors.deepPurple.withOpacity(1.0),
                      alignment: Alignment(0, 0.35)),
                  Column(
                    children: <Widget>[
                      Text('Please complete the information below',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.left),
                      new Spacer(),
                      Column(
                        children: <Widget>[
                          Text('address_kana',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              textAlign: TextAlign.left),
                          TextFormField(
                            initialValue: "トウキョウ",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]["city"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'city'),
                          ),
                          TextFormField(
                            initialValue: "２－３９ー７",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]["line1"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'line1'),
                          ),
                          TextFormField(
                            initialValue: "イリヤ",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]["line2"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'line2'),
                          ),
                          TextFormField(
                            initialValue: "110-0013",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]
                                  ["postal_code"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'postal_code'),
                          ),
                          TextFormField(
                            initialValue: "トウキョウト",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]["state"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'state'),
                          ),
                          TextFormField(
                            initialValue: "イリヤ",
                            onChanged: (text) {
                              infoObj["individual"]["address_kana"]["town"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'town'),
                          ),
                          Text('address_kanji',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              textAlign: TextAlign.left),
                          TextFormField(
                            initialValue: "東京",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]["city"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'city'),
                          ),
                          TextFormField(
                            initialValue: "２－３９ー７",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]["line1"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'line1'),
                          ),
                          TextFormField(
                            initialValue: "入谷",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]["line2"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'line2'),
                          ),
                          TextFormField(
                            initialValue: "110-0013",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]
                                  ["postal_code"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'postal_code'),
                          ),
                          TextFormField(
                            initialValue: "東京都",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]["state"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'state'),
                          ),
                          TextFormField(
                            initialValue: "台東区",
                            onChanged: (text) {
                              infoObj["individual"]["address_kanji"]["town"] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'town'),
                          ),
                          Text('date of birth',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              textAlign: TextAlign.left),
                          TextFormField(
                            initialValue: "28",
                            onChanged: (text) {
                              infoObj["dob"]["day"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'day'),
                          ),
                          TextFormField(
                            initialValue: "12",
                            onChanged: (text) {
                              infoObj["dob"]["month"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'month'),
                          ),
                          TextFormField(
                            initialValue: "1993",
                            onChanged: (text) {
                              infoObj["dob"]["year"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'year'),
                          ),
                          Text('other information',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              textAlign: TextAlign.left),
                          TextFormField(
                            initialValue: "male",
                            onChanged: (text) {
                              infoObj["gender"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'gender'),
                          ),
                          TextFormField(
                            initialValue: "和",
                            onChanged: (text) {
                              infoObj["first_name_kanji"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'first_name_kanji'),
                          ),
                          TextFormField(
                            initialValue: "ア",
                            onChanged: (text) {
                              infoObj["first_name_kana"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'first_name_kana'),
                          ),
                          TextFormField(
                            initialValue: "和",
                            onChanged: (text) {
                              infoObj["last_name_kanji"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'last_name_kanji'),
                          ),
                          TextFormField(
                            initialValue: "ア",
                            onChanged: (text) {
                              infoObj["last_name_kana"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'last_name_kana'),
                          ),
                          TextFormField(
                            initialValue: "+815031362394",
                            onChanged: (text) {
                              infoObj["individual"]["phone"] = text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'phone'),
                          ),
                          Text('bank account',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              textAlign: TextAlign.left),
                          TextFormField(
                            initialValue: "0001234",
                            onChanged: (text) {
                              infoObj["external_account"]['account_number'] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'account_number'),
                          ),
                          TextFormField(
                            initialValue: "1100000",
                            onChanged: (text) {
                              infoObj["external_account"]['routing_number'] =
                                  text;
                            },
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                hintText: 'routing_number'),
                          ),
                          InkWell(
                            highlightColor: Colors.red.shade300,
                            splashColor: Colors.red.shade100,
                            child: Text(
                              "Stripe terms of agreement",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18),
                            ),
                            onTap: () async {
                              if (await canLaunch(
                                  "https://stripe.com/en-gb-jp/connect-account/legal")) {
                                await launch(
                                    "https://stripe.com/en-gb-jp/connect-account/legal");
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _saving = true;
                                      });
                                      print(infoObj);
                                      var response = await http.put(
                                          "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/stripe",
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: convert.jsonEncode(infoObj));
                                      print(response.statusCode);
                                      print(response.body);
                                      setState(() {
                                        _saving = false;
                                        _finished = true;
                                        if (response.statusCode == 200) {
                                          _response = "Account Created!";
                                        }
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 2000),
                                          () {
                                        setState(() {
                                          _finished = false;
                                        });
                                      });
                                    },
                                    child: Text("Submit"),
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
              ),
            ),
            inAsyncCall: _saving,
            color: Colors.deepPurple,
            progressIndicator: CircularProgressIndicator()));
  }
}
