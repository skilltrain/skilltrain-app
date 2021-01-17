import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './authentication_services/auth_credentials.dart';
import '../../utils/alert_dialogue.dart';

class LoginPage extends StatefulWidget {
  final Future<List> Function(AuthCredentials login) didProvideCredentials;
  final VoidCallback shouldShowSignUp;
  LoginPage({Key key, this.didProvideCredentials, this.shouldShowSignUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(children: [
            _loginForm(),
            Container(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: widget.shouldShowSignUp,
                  child: Text('Don\'t have an account? Sign up.')),
            )
          ])),
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.person), labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        FlatButton(
            onPressed: () {
              _login();
            },
            child: Text('Login'),
            color: Theme.of(context).accentColor)
      ],
    );
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');

    final credentials =
        LoginCredentials(username: username, password: password);

    // This is a custom object (list) with a string at index 0 to indicate whether or not the login was successful
    // If the login was unsuccessful, index 0 is 'error' and there are error messages at indexes 1, 2, 3 etc.
    final loginResponse = await widget.didProvideCredentials(credentials);
    if (loginResponse[0] == "errors") {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogue(
              title: 'Error', content: loginResponse[1], buttonText: 'CLOSE'));
    }
  }
}
