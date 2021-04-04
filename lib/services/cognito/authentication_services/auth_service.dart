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
enum AuthFlowStatus { login, signUp, verification, tutorial, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  AuthCredentials _credentials;
  bool isTrainer;
  List<CognitoUserAttribute> attributes;
  CognitoUser cognitoUser;
  final userPool = new CognitoUserPool(
      "ap-northeast-1_oS6Gjckyt", "2lmha2vleftrnk996svvk2jf7r");

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showVerification() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  void showTutorial() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.tutorial);
    authStateController.add(state);
  }

  void showSession() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  Future<Map<String, String>> getLocallySavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    return {'username': username, 'password': password};
  }

  Future<void> setLocallySavedUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    return;
  }

  Future checkTrainer() async {
    if (_credentials == null) {
      final savedUser = await getLocallySavedUser();
      _credentials = LoginCredentials(
          username: savedUser['username'], password: savedUser['password']);
    }
    cognitoUser = new CognitoUser(_credentials.username, userPool);
    final authDetails = new AuthenticationDetails(
        username: _credentials.username, password: _credentials.password);
    await cognitoUser.authenticateUser(authDetails);
    attributes = await cognitoUser.getUserAttributes();
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

  Future<List> loginWithCredentials(
      AuthCredentials credentials, bool firstTime) async {
    var loginResult = ['no errors'];
    try {
      final userAuthenticationStatus = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);
      if (userAuthenticationStatus.isSignedIn) {
        deleteEliotsStripeAcc();
        this._credentials = credentials;
        await setLocallySavedUser(credentials.username, credentials.password);
        await this.checkTrainer();
        if (!firstTime) {
          showSession();
        }
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
      } else {
        //Fail safe for uncaught error
        loginResult.add(authError.exceptionList[1].detail);
      }
    }
    return loginResult;
  }

  Future<List> signUpWithCredentials(SignUpCredentials credentials) async {
    var signUpResult = ['no errors'];
    try {
      final userAttributes = [
        new AttributeArg(
            name: 'custom:isTrainer', value: credentials.isTrainer.toString()),
        new AttributeArg(name: 'custom:paymentSigned', value: 'false'),
        new AttributeArg(name: 'email', value: credentials.email),
        new AttributeArg(name: 'given_name', value: credentials.firstName),
        new AttributeArg(name: 'family_name', value: credentials.lastName),
      ];
      await userPool.signUp(credentials.username, credentials.password,
          userAttributes: userAttributes);
      this._credentials = credentials;
      showVerification();
    } on CognitoClientException catch (e) {
      print(e);
      signUpResult[0] = 'errors';
      if (e.code == 'UsernameExistsException' ||
          e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
        signUpResult.add(e.message);
      } else {
        signUpResult.add(e.message);
      }
    } catch (e) {
      print(e);
      signUpResult[0] = 'errors';
      final errorDetail = e.message.substring(e.message.indexOf(':') + 1);
      if (errorDetail.contains('password')) {
        // This shouldn't trigger, as form will be validated in frontend logic
        if (errorDetail.contains('length')) {
          signUpResult.add('Password must be at least six characters');
        }
      }
      if (errorDetail.contains('User')) {
        signUpResult.add(errorDetail);
      }
      if (errorDetail.contains('email')) {
        if (errorDetail.contains('format')) {
          signUpResult.add(errorDetail.substring(0, errorDetail.length - 1));
        }
      } else {
        //Fail safe for uncaught error
        signUpResult.add(e.message());
      }
    }
    return signUpResult;
  }

  Future<List> verifyCode(String verificationCode) async {
    var verifyResult = ['no errors'];
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials.username, confirmationCode: verificationCode);
      if (result.isSignUpComplete) {
        await loginWithCredentials(_credentials, true);
        await createUser(_credentials);
      }
    } on AuthError catch (authError) {
      verifyResult[0] = 'errors';
      verifyResult.add(authError.exceptionList[1].detail);
      print('Could not verify code - ${authError.cause}');
    }
    return verifyResult;
  }

  void logOut() async {
    try {
      await Amplify.Auth.signOut();
      showLogin();
    } on AuthError catch (authError) {
      print('Could not log out - ${authError.cause}');
    }
  }

  void checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      await this.checkTrainer(); // Sufficiently blocks line 138 before 141
      deleteEliotsStripeAcc();
      showSession();
    } catch (e) {
      showLogin();
      print('Could not authenticate user - $e');
    }
  }

  void deleteEliotsStripeAcc() async {
    //Special function for Eliot so that his stripe always resets for the demo
    //every time athtrainer logs in
    if (this._credentials.username == 'athtrainer') {
      final userAttributes = [
        new CognitoUserAttribute(name: 'custom:paymentSigned', value: 'false'),
      ];
      cognitoUser = new CognitoUser('athtrainer', userPool);
      final authDetails = new AuthenticationDetails(
          username: 'athtrainer', password: 'aeroplane');
      await cognitoUser.authenticateUser(authDetails);
      try {
        await cognitoUser.updateAttributes(userAttributes);
      } catch (e) {
        print(e);
      }
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
        'profilePhoto': 'images/trainers/default/profilePhoto/profile.png',
        'firstName': credentials.firstName,
        'lastName': credentials.lastName,
        'bio':
            'As a physiologist and physician, I believe in integrating the scientific aspects of training with the joy and appreciation for the sport I’ve gained over thirty years of running and racing on trails, roads, and track.  My goal is to help build a varied, sensible training plan that fits into your busy lifestyle, and will help you reach the finish line happy, healthy, and enthusiastic for whatever challenges lie ahead.',
        // 'price': 35, //Wrong - Eliot
        'genre': 'Running',
        "avgRating": 0,
        "numberOfRatings": 0,
        "totalRating": 0,
      }),
    );
  }
}
