// Define basic credentials
abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({this.username, this.password});
}

// Define login credentials
class LoginCredentials extends AuthCredentials {
  LoginCredentials({String username, String password})
      : super(username: username, password: password);
}

// Define full credentials
class SignUpCredentials extends AuthCredentials {
  final String email;
  final bool isTrainer;

  SignUpCredentials(
      {String username,
      String password,
      this.email,
      this.isTrainer,
      String lastName,
      String firstName})
      : super(username: username, password: password);
}
