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
