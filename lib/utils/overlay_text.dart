import 'package:flutter/material.dart';

class OverlayText extends StatefulWidget {
  final Color color;
  final Alignment alignment;
  final String text;
  OverlayText({Key key, this.color, this.alignment, this.text})
      : super(key: key);
  @override
  _OverlayTextState createState() => _OverlayTextState();
}

class _OverlayTextState extends State<OverlayText> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: widget.alignment,
        child: Text(widget.text,
            style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.bold,
                fontSize: 40.0),
            textAlign: TextAlign.center));
  }
}
