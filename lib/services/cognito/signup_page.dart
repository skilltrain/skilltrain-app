import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './authentication_services/auth_credentials.dart';
import '../../utils/alert_dialogue.dart';

enum SingingCharacter { lafayette, jefferson }
SingingCharacter _character = SingingCharacter.lafayette;

class SignUpPage extends StatefulWidget {
  final Future<List> Function(SignUpCredentials signUpCredentials)
      didProvideCredentials;
  final VoidCallback shouldShowLogin;
  final setTrainer;
  final getTrainer;

  SignUpPage(
      {Key key,
      this.didProvideCredentials,
      this.shouldShowLogin,
      this.setTrainer,
      this.getTrainer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isTrainer = false;
  final _formKey = GlobalKey<FormState>();
  final userNames = [];
  bool _signingUp = false;

  void initState() {
    super.initState();
  }

  void _signUp() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      setState(() {
        _signingUp = true;
      });
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      print('username: $username');
      print('email: $email');
      print('password: $password');
      print('isTrainer: $isTrainer');

      isTrainer = widget.getTrainer();

      final credentials = SignUpCredentials(
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          password: password,
          isTrainer: isTrainer);
      final signUpResponse = await widget.didProvideCredentials(credentials);
      if (signUpResponse[0] == "errors") {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialogue(
                title: 'Error',
                content: signUpResponse[1],
                buttonText: 'CLOSE'));
      }
      setState(() {
        _signingUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
            child: SingleChildScrollView(
                child: Container(
              width: double.infinity,
              child: Column(children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.green,
                      child: Image.asset('assets/images/signup.png',
                          fit: BoxFit.cover),
                    ),
                    Container(
                      width: double.infinity,
                      height: 530,
                      child: Column(children: [
                        new Spacer(),
                        Text(
                          "Find your workout buddy",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0,
                          ),
                        ),
                        new Spacer(),
                      ]),
                    ),
                    Container(
                        width: double.infinity,
                        height: 450,
                        child: Center(
                          child: Container(
                            height: 100,
                            child: Image.asset('assets/icon/icon.png'),
                          ),
                        )),
                  ],
                ),
                // User or Trainer
                Center(child: radioButton()),
                // Sign Up Form
                _signUpForm(),

                // Login Button
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: widget.shouldShowLogin,
                      child: Text('Already have an account? Login.')),
                )
              ]),
            )),
            inAsyncCall: _signingUp,
            color: Colors.deepPurple,
            progressIndicator: CircularProgressIndicator()));
  }

  Widget radioButton() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('User'),
          leading: Radio(
            value: SingingCharacter.lafayette,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                isTrainer = false;
                widget.setTrainer(isTrainer);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Trainer'),
          leading: Radio(
            value: SingingCharacter.jefferson,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                isTrainer = true;
                widget.setTrainer(isTrainer);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              controller: _firstNameController,
              decoration: InputDecoration(
                  icon: Icon(Icons.face), labelText: 'First Name'),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              controller: _lastNameController,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_box), labelText: 'Last Name'),
            ),

            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              controller: _usernameController,
              decoration: InputDecoration(
                  icon: Icon(Icons.person), labelText: 'Username'),
            ),

            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              controller: _emailController,
              decoration:
                  InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
            ),

            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least six characters';
                }
                return null;
              },
              controller: _passwordController,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock_open), labelText: 'Password'),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),

            // Sign Up Button
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: _signUp,
                  child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).accentColor),
            )
          ],
        ),
      ),
    );
  }
}
