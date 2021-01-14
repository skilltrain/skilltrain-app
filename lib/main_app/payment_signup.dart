import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class PaymentSignup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PaymentState();
  }
}

class PaymentState extends State<PaymentSignup> {
  final Map<String, dynamic> infoObj = {
    "individual": {
      "address_kana": {
        "city": "",
        "line1": "",
        "line2": "",
        "postal_code": "",
        "state": "",
        "town": ""
      },
      "address_kanji": {
        "city": "",
        "line1": "",
        "line2": "",
        "postal_code": "",
        "state": "",
        "town": ""
      },
      "dob": {"day": "", "month": "", "year": ""},
      "email": "",
      "gender": "",
      "first_name_kanji": "",
      "first_name_kana": "",
      "last_name_kanji": "",
      "last_name_kana": ""
    },
    "external_account": {"account_number": "", "routing_number": ""},
    "phone": ""
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Payment Informatin Fillout Form'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 1400,
            child: Column(
              children: <Widget>[
                Text('Please fill out below information',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.left),
                new Spacer(),
                Column(
                  children: <Widget>[
                    Text('address_kana',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextFormField(
                      initialValue: "トウキョウ",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["city"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'city'),
                    ),
                    TextFormField(
                      initialValue: "２－３９ー７",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["line1"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line1'),
                    ),
                    TextFormField(
                      initialValue: "イリヤ",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["line2"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line2'),
                    ),
                    TextFormField(
                      initialValue: "110-0013",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["postal_code"] =
                            text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'postal_code'),
                    ),
                    TextFormField(
                      initialValue: "トウキョウト",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["state"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'state'),
                    ),
                    TextFormField(
                      initialValue: "イリヤ",
                      onChanged: (text) {
                        infoObj["individual"]["address_kana"]["town"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'town'),
                    ),
                    Text('address_kanji',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextFormField(
                      initialValue: "東京",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["city"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'city'),
                    ),
                    TextFormField(
                      initialValue: "２－３９ー７",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["line1"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line1'),
                    ),
                    TextFormField(
                      initialValue: "入谷",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["line2"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line2'),
                    ),
                    TextFormField(
                      initialValue: "110-0013",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["postal_code"] =
                            text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'postal_code'),
                    ),
                    TextFormField(
                      initialValue: "東京都",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["state"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'state'),
                    ),
                    TextFormField(
                      initialValue: "台東区",
                      onChanged: (text) {
                        infoObj["individual"]["address_kanji"]["town"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'town'),
                    ),
                    Text('date of birth',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
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
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextFormField(
                      initialValue: "ejaustinforbes@gmail.com",
                      onChanged: (text) {
                        infoObj["email"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'email'),
                    ),
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
                      initialValue: "",
                      onChanged: (text) {
                        infoObj['username'] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'username'),
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
                        infoObj["phone"] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'phone'),
                    ),
                    Text('bank account',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextFormField(
                      initialValue: "0001234",
                      onChanged: (text) {
                        infoObj["external_account"]['account_number'] = text;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'account_number'),
                    ),
                    TextFormField(
                      initialValue: "1100000",
                      onChanged: (text) {
                        infoObj["external_account"]['routing_number'] = text;
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
                              onPressed: () => print(jsonEncode(infoObj)),
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
            ),
          ),
        ));
  }
}
