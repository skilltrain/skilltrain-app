import 'package:flutter/material.dart';

class TrainerFilter extends StatefulWidget {
  @override
  _TrainerFilterState createState() => _TrainerFilterState();
}

class _TrainerFilterState extends State<TrainerFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter Page"),
        ),
        body: Center(child: Text("This is thefilter page")));
  }
}
