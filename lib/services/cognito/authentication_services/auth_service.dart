import 'dart:async';
import 'dart:core';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './auth_credentials.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Specify session flow
enum AuthFlowStatus { login, signUp, verification, tutorial, session, loading }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  AuthCredentials _credentials;
  bool isTrainer;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  Future checkTrainer() async {
    final userPool = new CognitoUserPool(
        "ap-northeast-1_4KL7XZGPF", "2gog45e490ahlnk1hq0dp18ck4");
    if (_credentials == null) {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final password = prefs.getString('password');
      _credentials = LoginCredentials(username: username, password: password);
    }
    final CognitoUser user = new CognitoUser(_credentials.username, userPool);
    final authDetails = new AuthenticationDetails(
        username: _credentials.username, password: _credentials.password);
    await user.authenticateUser(authDetails);
    List<CognitoUserAttribute> attributes = await user.getUserAttributes();
    attributes.forEach((attribute) {
      if (attribute.getName() == 'custom:isTrainer') {
        if (attribute.getValue() == 'true') {
          isTrainer = true;
        } else {
          isTrainer = false;
        }
      }
    });
  }

  Future<List> loginWithCredentials(AuthCredentials credentials) async {
    var loginResult = ['no errors'];
    try {
      final userAuthenticationStatus = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);
      if (userAuthenticationStatus.isSignedIn) {
        final loadingState = AuthState(authFlowStatus: AuthFlowStatus.loading);
        authStateController.add(loadingState);
        this._credentials = credentials;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', credentials.username);
        prefs.setString('password', credentials.password);
        await this.checkTrainer();
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        print('User could not be signed in');
      }
    } on AuthError catch (authError) {
      loginResult[0] = 'errors';
      print('Could not login - ${authError.cause}');
      final errorDetail = authError.exceptionList[1].detail;
      if (errorDetail.startsWith('Incorrect username or password.')) {
        loginResult.add('Incorrect password');
      }
      if (errorDetail.startsWith('User does not exist')) {
        loginResult.add("User does not exist");
      }
    }
    return loginResult;
  }

  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {
        'email': credentials.email,
        'isTrainer': credentials.isTrainer.toString()
      };
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
        await createUser(_credentials);
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
      await this.checkTrainer(); // Sufficiently blocks line 138 before 141
      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (e) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
      print('Could not authenticate user - $e');
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
      body: convert.jsonEncode(<String, dynamic>{
        "id": date,
        'username': credentials.username,
        'email': credentials.email,
        'profilePhoto': 'images/trainers/default/profilePhoto/profile.jpg',
        'instructor': 'Evans Clark',
        'firstName': 'Evans',
        'lastName': 'Clark',
        'sessionPhoto':
            'images/trainers/default/profilePhoto/sessionPhoto4.jpg',
        'bio':
            'As a physiologist and physician, I believe in integrating the scientific aspects of training with the joy and appreciation for the sport I’ve gained over thirty years of running and racing on trails, roads, and track.  My goal is to help build a varied, sensible training plan that fits into your busy lifestyle, and will help you reach the finish line happy, healthy, and enthusiastic for whatever challenges lie ahead.',
        'price': 35,
        'genre': 'Running',
        "avgRating": 0,
        "numberOfRatings": 0,
        "totalRating": 0,
      }),
    );
  }
}
