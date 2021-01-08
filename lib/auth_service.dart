import 'dart:async';
import 'dart:io';

import 'auth_credentials.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';

enum AuthFlowStatus { login, signUp, verification, tutorial, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  AuthCredentials _credentials;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  Future<List> loginWithCredentials(AuthCredentials credentials) async {
    var loginResult = ['no errors'];
    try {
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);

      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        print('User could not be signed in');
      }
      return loginResult;
    } on AuthError catch (authError) {
      loginResult[0] = 'errors';
      print('Could not login - ${authError.cause}');
      final errorDetail = authError.exceptionList[1].detail;
      final errorDetailSimplified =
          errorDetail.substring(0, errorDetail.indexOf('('));
      print('Error simplified - $errorDetailSimplified');

      if (errorDetailSimplified == 'User does not exist. ') {
        loginResult.add(errorDetailSimplified);
      }
      return loginResult;
    }
  }

  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};
      await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      this._credentials = credentials;
      final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
      authStateController.add(state);
    } on AuthError catch (authError) {
      print('Failed to sign up - ${authError.cause}');
    }
  }

  void verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials.username, confirmationCode: verificationCode);
      if (result.isSignUpComplete) {
        final response = await loginWithCredentials(_credentials);
        final state = AuthState(authFlowStatus: AuthFlowStatus.tutorial);
        authStateController.add(state);
      } else {}
    } on AuthError catch (authError) {
      print('Could not verify code - ${authError.cause}');
    }
  }

  void logOut() async {
    try {
      await Amplify.Auth.signOut();
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    } on AuthError catch (authError) {
      print('Could not log out - ${authError.cause}');
    }
  }

  void checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));

      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } on AuthError catch (e) {
      print(e);
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}