import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget sessionCard(
    {String name,
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
        elevation: 4.0,
        child: InkWell(
          splashColor: Colors.cyanAccent,
          onTap: function,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 24, bottom: 24),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Trainer",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
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

/*
                              Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                                child:FractionallySizedBox(
                                  widthFactor: 0.8,
                                  heightFactor: 1.0,
                                child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      new Spacer(),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[

                                            new Spacer(),

                                          Container(
                                            child: Column(
                                              children: [

                                                FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: Container(
                                                    child:Text("Trainer",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(fontSize: 15,),
                                                    ),
                                                  )
                                                ),
                                                FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: Container(
                                                  child:Text(name,
                                                    style: TextStyle(fontSize: 20,),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                                
                                              ],
                                            ),
                                          ),

                                            new Spacer(),

                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    date,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),

                                                  Text(
                                                    startTime+ " - " +
                                                    endTime, 
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),


                                                  ]),
                                              new Spacer(),
                                            ]),
                                          new Spacer(),
                                      ],
                                    )
                                    //)
                                    )
  ),
                              );
*/
}
