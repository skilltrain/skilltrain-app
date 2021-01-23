import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TraineeSessionDetailsPage extends StatefulWidget {
  final String sessionID;
  TraineeSessionDetailsPage({this.sessionID});
  @override
  _TraineeSessionDetailsPageState createState() =>
      _TraineeSessionDetailsPageState();
}

class _TraineeSessionDetailsPageState extends State<TraineeSessionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Session Details and Chat"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.details)),
                Tab(icon: Icon(Icons.chat)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //THIS IS THE DETAILS PAGE
              Text("This will be the details page"),
              //THIS IS THE CHAT TAB
              Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: ["messages", "array", "length"].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                "This is a message that wll come from the messages object");
                          }),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: "Type a message"),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.send), onPressed: () => {}),
                    ],
                  )
                ],
              )
            ],
          )),
    ));
  }
}
