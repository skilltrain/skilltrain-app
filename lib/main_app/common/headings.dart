import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Widget sectionTitle({String title}) {
  return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.symmetric(horizontal: 50),
      padding: EdgeInsets.only(top: 20),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey[900], fontSize: 35, fontWeight: FontWeight.w800),
      ));
}

Widget blackHeading({String title, bool underline}) {
  if (underline) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 1,
        // This can be the space you need betweeb text and underline
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.purple,
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
