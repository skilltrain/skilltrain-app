import 'package:flutter/material.dart';
import './video_session/video_session.dart';

class BookingStatus extends StatelessWidget {
  final int index;
  BookingStatus({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("booking status"),
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Row(children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("sample schedule",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                      Text("Instructor name",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text("XX:00 - XX:30",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                    ]),
                new Spacer(),
                RaisedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionList(),
                      ),
                    )
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
                    child: const Text('see detail'),
                  ),
                ),
              ]));
            },
            itemCount: 10));
  }
}
