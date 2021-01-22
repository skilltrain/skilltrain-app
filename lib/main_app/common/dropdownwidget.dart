import 'package:flutter/material.dart';

//Reuseable title widget

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
            child: DropdownButton<String>(
              underline: Container(color: Colors.transparent),
              value: widget.value,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[900]),
              iconSize: 24,
              style: TextStyle(fontWeight: FontWeight.bold),
              onChanged: widget.onChanged,
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Colors.grey[900], fontSize: 18)),
                );
              }).toList(),
            )),
      ),
    );
  }
}
