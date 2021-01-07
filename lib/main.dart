import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';
import './signup.dart';
import './login.dart';
import './auth_service.dart';
import './verification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  final _authService = AuthService();
  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    // This has been turned off so that Yuta can access the session
    // _authService.checkAuthStatus();

//This
    _authService.showSession();
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
      setState(() {
        _amplifyConfigured = true;
      });
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
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: StreamBuilder<AuthState>(
            stream: _authService.authStateController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Navigator(
                  pages: [
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
                      MaterialPage(
                          child: LoginPage(
                              didProvideCredentials:
                                  _authService.loginWithCredentials,
                              shouldShowSignUp: _authService.showSignUp)),
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
                                  _authService.verifyCode))
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
