import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Widget cyanButton({String text, VoidCallback function}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        primary: Colors.cyanAccent, // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: function,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)));
}
