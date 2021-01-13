import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class PaymentSignup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PaymentState();
  }
}

class PaymentState extends State<PaymentSignup> {
  final _channelController = TextEditingController();

  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _frameRateController = TextEditingController();

  String _codec = "h264";
  String _mode = "live";

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _frameRateController.dispose();
    super.dispose();
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
          title: Text('Payment Informatin Fillout Form'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 1500,
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
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'city'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line1'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line2'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'postal_code'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'state'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'town'),
                    ),
                    Text('address_kanji',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'city'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line1'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'line2'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'postal_code'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'state'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'town'),
                    ),
                    Text('date of birth',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'day'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'month'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'year'),
                    ),
                    Text('other information',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'email'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'gender'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'first_name_kanji'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'first_name_kana'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'last_name_kanji'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'last_name_kana'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'phone'),
                    ),
                    Text('external_account',
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'account_number'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          hintText: 'routing_number'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => print(111),
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
