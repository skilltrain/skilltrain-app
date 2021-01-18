import 'package:flutter/material.dart';

class TrainerFilter extends StatefulWidget {
  @override
  _TrainerFilterState createState() => _TrainerFilterState();
}

class _TrainerFilterState extends State<TrainerFilter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Filter Page")),
        body: Container(child: Text("This is the filter page")));
  }
}
