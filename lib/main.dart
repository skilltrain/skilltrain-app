import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';
import './authentication/signup_page.dart';
import './authentication/login_page.dart';
import './authentication/authentication_services/auth_service.dart';
import './authentication/verification_page.dart';
import './main_app/home_page.dart';
import './main_app/tutorial_flow.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    _authService.checkAuthStatus();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    amplifyInstance.addPlugin(authPlugins: [authPlugin]);
    amplifyInstance.addPlugin(analyticsPlugins: [analyticsPlugin]);

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
                              shouldShowLogin: _authService.showLogin)),
                    if (snapshot.data.authFlowStatus ==
                        AuthFlowStatus.verification)
                      MaterialPage(
                          child: VerificationPage(
                              didProvideVerificationCode:
                                  _authService.verifyCode)),
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.tutorial)
                      MaterialPage(child: Tutorial()),
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
                      MaterialPage(
                          child: HomePage(shouldLogOut: _authService.logOut)),
                  ],
                  onPopPage: (route, result) => route.didPop(result),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
