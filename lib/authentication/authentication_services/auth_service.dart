import 'dart:async';
import './auth_credentials.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Specify session flow
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
        await loginWithCredentials(_credentials);
        final response = await createUser(_credentials);
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

  Future<http.Response> createUser(SignUpCredentials credentials) {
    var postUrl;
    credentials.isTrainer
        ? postUrl =
            'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers'
        : postUrl =
            'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/users';

    final date = DateTime.now().millisecondsSinceEpoch.toString();
    return http.post(
      postUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        "id": date,
        'username': credentials.username,
        'email': credentials.email,
        'portrait':
            'https://image.freepik.com/free-photo/side-view-of-fit-man-posing-while-wearing-tank-top-with-crossed-arms_23-2148700611.jpg',
        'instructor': 'Evans Clark',
        'classPhoto':
            'https://www.sciencemag.org/sites/default/files/styles/article_main_large/public/1036780592-1280x720.jpg?itok=QykjHcAC',
        'bio':
            'As a physiologist and physician, I believe in integrating the scientific aspects of training with the joy and appreciation for the sport I’ve gained over thirty years of running and racing on trails, roads, and track.  My goal is to help build a varied, sensible training plan that fits into your busy lifestyle, and will help you reach the finish line happy, healthy, and enthusiastic for whatever challenges lie ahead.',
        'price': '35',
        'genre': 'Running',
        'availability': '[]'
      }),
    );
  }
}
