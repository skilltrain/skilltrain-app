import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Widget sectionTitle({String title}) {
  return Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
      ));
}

Widget blackHeading({String title, bool underline, bool purple}) {
  if (underline) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 1,
        // This can be the space you need betweeb text and underline
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: purple ? Colors.purple : Colors.cyanAccent,
        width: 8.0,

        // This would be the width of the underline
      ))),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
    );
  } else {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
    );
  }
}
