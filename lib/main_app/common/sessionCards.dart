import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget sessionCard(
    {bool trainer,
    String name,
    String date,
    String startTime,
    String endTime,
    VoidCallback function,
    context}) {
  //Create human readable time
  DateTime newDate = DateTime.parse(date);
  var format = new DateFormat("MMMEd");
  var dateString = format.format(newDate);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: InkWell(
          splashColor: Colors.cyanAccent,
          onTap: function,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 24, bottom: 24),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                trainer ? "Trainee" : "Trainer",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    dateString,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.timer,
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    startTime + " - " + endTime,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                            children: [Icon(Icons.keyboard_arrow_right)]),
                      ),
                    ]),
              ),
            ],
          ),
        )),
  );
}

Widget bookingCard(
    {String genre,
    String description,
    String startTime,
    String endTime,
    String date,
    VoidCallback function,
    context}) {
  //Create human readable time
  DateTime newDate = DateTime.parse(date);
  var format = new DateFormat("MMMEd");
  var dateString = format.format(newDate);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: InkWell(
          splashColor: Colors.cyanAccent,
          onTap: function,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 24, bottom: 24),
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              genre,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              description.length > 2
                                  ? description
                                  : "This trainer has not added any details about this session.",
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                              ),
                              Text(
                                dateString,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.timer,
                                  size: 16,
                                ),
                              ),
                              Text(
                                startTime + " - " + endTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(children: [Icon(Icons.keyboard_arrow_right)]),
                  ),
                ]),
              ),
            ],
          ),
        )),
  );
}
