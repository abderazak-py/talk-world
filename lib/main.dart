import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_world/Screens/ForgotPassword.dart';
import 'package:talk_world/Screens/Login.dart';
import 'package:talk_world/Screens/Onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talk_world/Screens/ProfilePage.dart';
import 'package:talk_world/Screens/Register.dart';
import 'package:talk_world/Screens/WorldsList.dart';
import 'package:talk_world/component/consts.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(Home(
    showHome: showHome,
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class Home extends StatelessWidget {
  final bool showHome;
  const Home({Key? key, required this.showHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: showHome ? SignInOrNot() : OnboardingPage(),
    );
  }
}

class SignInOrNot extends StatelessWidget {
  const SignInOrNot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        loginPageRoute: (context) => Login(),
        registerPageRoute: (context) => Register(),
        forgotPageRoute: (context) => ForgotPassword(),
        profilePageRoute: (context) => ProfilePage(),
      },
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return WorldsList();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
