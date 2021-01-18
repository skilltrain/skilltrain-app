import 'package:flutter/material.dart';
import './authentication_services/auth_credentials.dart';

enum SingingCharacter { lafayette, jefferson }
SingingCharacter _character = SingingCharacter.lafayette;

class SignUpPage extends StatefulWidget {
  final ValueChanged<SignUpCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;

  SignUpPage({Key key, this.didProvideCredentials, this.shouldShowLogin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isTrainer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: SizedBox(
                    height: kToolbarHeight,
                    child: Image.asset('assets/images/skillTrain-logo.png', fit: BoxFit.scaleDown)),
            centerTitle: true,
          backgroundColor: Colors.purple),
          body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
              child: Column(children: [
                // Image of Fit Girl

                Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/images/signupgirl.jpg')),

                // Sign Up Form
                _signUpForm(),

                // Trainer of user radio button
                Center(child: radioButton()),

                // Login Button
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: widget.shouldShowLogin,
                      child: Text('Already have an account? Login.')),
                )
              ]),
          )
    )
    );
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
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _signUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.person), labelText: 'Username'),
        ),

        // Email TextField
        TextField(
          controller: _emailController,
          decoration:
              InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
        ),

        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        // Sign Up Button
        FlatButton(
            onPressed: _signUp,
            child: Text('Sign Up'),
            color: Theme.of(context).accentColor)
      ],
    );
  }

  void _signUp() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('email: $email');
    print('password: $password');
    print('isTrainer: $isTrainer');

    final credentials = SignUpCredentials(
        username: username,
        email: email,
        password: password,
        isTrainer: isTrainer);
    widget.didProvideCredentials(credentials);
  }
}
