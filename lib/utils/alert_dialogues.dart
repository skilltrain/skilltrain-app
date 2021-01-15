import 'package:flutter/material.dart';

class AlertDialogues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showAlertDialog(BuildContext context, String errorMessage) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(errorMessage),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
