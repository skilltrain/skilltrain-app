import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth_credentials.dart';

class LoginPage extends StatefulWidget {
  // I am not sure what deleting ValueChanged here breaks, but I need to return a list from didProvideCredentials to
  // print the error message here
  // final ValueChanged<LoginCredentials> didProvideCredentials;

  // This is the replacement for ValueChanged, I do not know if this will break things later - Eliot
  Future<List> Function(AuthCredentials login) didProvideCredentials;

  final VoidCallback shouldShowSignUp;
  LoginPage({Key key, this.didProvideCredentials, this.shouldShowSignUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 2
    return Scaffold(
      // 3
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 40),
          // 4
          child: Stack(children: [
            // Login Form
            _loginForm(),

            // 6
            // Sign Up Button
            Container(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: widget.shouldShowSignUp,
                  child: Text('Don\'t have an account? Sign up.')),
            )
          ])),
    );
  }

  // 5
  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.mail), labelText: 'Username'),
        ),

        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        // Login Button
        FlatButton(
            onPressed: () {
              _login();
            },
            child: Text('Login'),
            color: Theme.of(context).accentColor)
      ],
    );
  }

  void showAlertDialog(BuildContext context, String errorMessage) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(errorMessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');

    final credentials =
        LoginCredentials(username: username, password: password);

    // This is a custom object (list) with a boolean at index 0 to indicate whether or not the login was unsuccessful
    // If the login was unsuccessful, the boolean is 'true' and there are error messages at indexes 1,2,3 etc.
    final loginResponse = await widget.didProvideCredentials(credentials);
    print(loginResponse);
    if (loginResponse[0] == "errors") {
      showAlertDialog(context, loginResponse[1]);
    }
  }
}
