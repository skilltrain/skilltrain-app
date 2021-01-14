import 'package:flutter/material.dart';
import '../services/stripe/payment/direct_payment_page.dart';
import './home_page.dart';

class Booking extends StatelessWidget {
  final int index;
  final String trainerUsername;
  Booking({this.index, this.trainerUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("booking"),
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Row(children: <Widget>[
                Text("sample schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                new Spacer(),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, SlideLeftRoute(page: MyHomePage(trainerUsername: trainerUsername)));
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.pink[300],
                          Colors.purple[500],
                          Colors.purple[700],
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Text('booking now'),
                  ),
                ),
              ]));
            },
            itemCount: 10));
  }
}
