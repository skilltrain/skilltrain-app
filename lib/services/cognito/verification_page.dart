import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:skilltrain/utils/alert_dialogue.dart';

class VerificationPage extends StatefulWidget {
  final Future<List> Function(String verificationCode)
      didProvideVerificationCode;

  VerificationPage({Key key, this.didProvideVerificationCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();
  bool _verifying = false;

  void initState() {
    super.initState();
  }

  void _verify() async {
    final verificationCode = _verificationCodeController.text.trim();
    final verifyResult =
        await widget.didProvideVerificationCode(verificationCode);
    if (verifyResult[0] == "errors") {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogue(
              title: 'Error', content: verifyResult[1], buttonText: 'CLOSE'));
    }
    _verifying = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 40),
            child: _verificationForm(),
          ),
          inAsyncCall: _verifying,
          progressIndicator: CircularProgressIndicator()),
    );
  }

  Widget _verificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Verification Code TextField
        TextField(
          controller: _verificationCodeController,
          decoration: InputDecoration(
              icon: Icon(Icons.confirmation_number),
              labelText: 'Verification code'),
        ),

        // Verify Button
        FlatButton(
            onPressed: () {
              setState(() {
                _verifying = true;
              });
              _verify();
            },
            child: Text('Verify'),
            color: Theme.of(context).accentColor)
      ],
    );
  }
}
