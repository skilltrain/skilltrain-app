import 'package:flutter/material.dart';

//Reuseable title widget
Widget _sectionTitle({String title}) {
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

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({
    Key key,
    @required this.value,
    @required this.items,
    @required this.onChanged,
  }) : super(key: key);

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Colors.cyan[600],
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0, style: BorderStyle.solid, color: Colors.cyan),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
            child: DropdownButton<String>(
              value: widget.value,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              iconSize: 24,
              elevation: 16,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              onChanged: widget.onChanged,
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.grey[900])),
                );
              }).toList(),
            )),
      ),
    );
  }
}
