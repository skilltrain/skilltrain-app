import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:skilltrain/main_app/common/buttons.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import 'package:skilltrain/main_app/trainer/pages/instructor_view/pages/instructor_register_course.dart';
import 'package:skilltrain/services/agora/video_session/index_trainer.dart';
import 'package:skilltrain/utils/sliders.dart';

class TrainerBookedSessionPage extends StatefulWidget {
  final String id;
  final String trainee;
  final String startTime;
  final String endTime;
  final String date;
  final String description;
  final String sessionCode;

  TrainerBookedSessionPage(
      {this.id,
      this.trainee,
      this.startTime,
      this.endTime,
      this.date,
      this.description,
      this.sessionCode});
  @override
  _TrainerBookedSessionPageState createState() =>
      _TrainerBookedSessionPageState();
}

class _TrainerBookedSessionPageState extends State<TrainerBookedSessionPage> {
  @override
  Widget build(BuildContext context) {
    DateTime newDate = DateTime.parse(widget.date);
    var format = new DateFormat("MMMEd");
    var dateString = format.format(newDate);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Color(0xFFFFFFFF),
              title: Text("Session Details and Chat"),
              bottom: TabBar(
                indicatorColor: Colors.cyanAccent,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.chat,
                    color: Colors.black,
                  )),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                //THIS IS THE DETAILS PAGE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            blackHeading(
                                title: "Your Session",
                                underline: false,
                                purple: false),
                            blackHeading(
                                title: "with " + widget.trainee,
                                underline: true,
                                purple: false)
                          ],
                        )),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 36),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          color: Colors.purple,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Session with",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text(dateString,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.trainee,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                  Text(widget.startTime + "-" + widget.endTime,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 36.0),
                              child: Text(
                                description.length > 2
                                    ? description
                                    : "This trainer has not added any details about this session.",
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(36.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      primary: Colors.cyanAccent, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: () => {
                                          Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: IndexPageTrainer(
                                                      sessionCode:
                                                          widget.sessionCode)))
                                        },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.video_call),
                                        Text("  Start Your Session Now",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
            )));
  }
}
