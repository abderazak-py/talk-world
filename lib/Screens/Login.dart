import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/consts.dart';
import 'package:talk_world/component/custom_button.dart';
import 'package:talk_world/component/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../component/Utils.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return MaterialApp(
      scaffoldMessengerKey: Utils1.messengerKey1,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Form(
              key: formkey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: h * .13),
                      Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                      ),
                      SizedBox(height: h * .05),
                      CustomTextField(
                        text: 'Email',
                        icon: FontAwesomeIcons.solidEnvelope,
                        hide: false,
                        controller: emailController,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                      SizedBox(height: h * .04),
                      CustomTextField(
                        text: 'Password',
                        icon: FontAwesomeIcons.lock,
                        hide: true,
                        controller: passwordController,
                        validator: (password) =>
                            password != null && password.length < 6
                                ? 'Enter min. 6 characters'
                                : null,
                      ),
                      SizedBox(height: h * .08),
                      CustomButton(text: 'Login', onPressed: () => signIn()),
                      SizedBox(height: h * .01),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'Forgot');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.red,
                          )),
                        ),
                      ),
                      SizedBox(height: h * .08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New here?',
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: Colors.white,
                            )),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, registerPageRoute);
                            },
                            child: Text(
                              'Register',
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: kBlueColor,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future signIn() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils1.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
