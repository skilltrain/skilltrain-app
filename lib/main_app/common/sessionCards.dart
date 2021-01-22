import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Widget sessionCards({String name, String date, String startTime, String endTime, context}) {
  return 


                               Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.8,
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
                                                Container(
                                                  width:MediaQuery.of(context).size.width *0.4,
                                                  child:Text("Trainer",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontSize: 15,),
                                                  ),
                                                ),
                                                Container(
                                                  width:MediaQuery.of(context).size.width *0.4,
                                                  child:Text(name,
                                                    style: TextStyle(fontSize: 20,),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                            new Spacer(),

                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    date + "  ",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),

                                                  Text(
                                                    startTime + " - " +
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