import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';
import './services/cognito/signup_page.dart';
import './services/cognito/login_page.dart';
import './services/cognito/authentication_services/auth_service.dart';
import './services/cognito/verification_page.dart';
import './main_app/trainer/home_page_trainer.dart';
import './main_app/trainee/home_page_trainee.dart';
import './main_app/common/tutorial_flow.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();
  bool isTrainerSignUp = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _authService.checkAuthStatus();
  }

  // These two methods are needed to persist the state of the
  // radio buttons on the sign up page. The variables stored in that page
  // are erased when switching views like signup -> login -> signup, however
  // the radio button position is kept in place. This way, the main app file
  // stores the boolean.
  void setTrainer(bool check) {
    isTrainerSignUp = check;
  }

  bool getTrainer() {
    return isTrainerSignUp;
  }

  void _configureAmplify() async {
    if (!mounted) return;
    // Add Pinpoint and Cognito Plugins
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyStorageS3 storage = AmplifyStorageS3();

    amplifyInstance.addPlugin(
        authPlugins: [authPlugin],
        storagePlugins: [storage],
        analyticsPlugins: [analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await amplifyInstance.configure(amplifyconfig);
    try {
      setState(() {});
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "skillTrain",
        theme: ThemeData(
            primarySwatch: Colors.purple,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: StreamBuilder<AuthState>(
            stream: _authService.authStateController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Navigator(
                  pages: [
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                      MaterialPage(
                          child: LoginPage(
                              didProvideCredentials:
                                  _authService.loginWithCredentials,
                              shouldShowSignUp: _authService.showSignUp)),
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
                      MaterialPage(
                          child: SignUpPage(
                              didProvideCredentials:
                                  _authService.signUpWithCredentials,
                              shouldShowLogin: _authService.showLogin,
                              setTrainer: setTrainer,
                              getTrainer: getTrainer)),
                    if (snapshot.data.authFlowStatus ==
                        AuthFlowStatus.verification)
                      MaterialPage(
                          child: VerificationPage(
                              didProvideVerificationCode:
                                  _authService.verifyCode,
                              shouldShowTutorial: _authService.showTutorial)),
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.tutorial)
                      MaterialPage(
                          child: TutorialOne(
                        // firstime = must change the authservice state after final page
                        shouldShowSession: _authService.showSession,
                        firstTime: true,
                      )),
                    if (snapshot.data.authFlowStatus ==
                            AuthFlowStatus.session &&
                        _authService.isTrainer)
                      MaterialPage(
                          child: HomePageTrainer(
                        shouldLogOut: _authService.logOut,
                        userAttributes: _authService.attributes,
                        cognitoUser: _authService.cognitoUser,
                      )),
                    if (snapshot.data.authFlowStatus ==
                            AuthFlowStatus.session &&
                        !_authService.isTrainer)
                      MaterialPage(
                          child: HomePageTrainee(
                              shouldLogOut: _authService.logOut,
                              userAttributes: _authService.attributes)),
                  ],
                  onPopPage: (route, result) => route.didPop(result),
                );
              } else {
                return Container(
                    height: MediaQuery.of(context).size.height - 87,
                    decoration:
                        new BoxDecoration(color: Colors.deepPurple[100]),
                    child: Center(child: CircularProgressIndicator()));
              }
            }));
  }
}
