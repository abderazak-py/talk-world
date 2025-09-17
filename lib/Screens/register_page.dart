import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/consts.dart';
import 'package:talk_world/component/custom_button.dart';
import 'package:talk_world/component/custom_textfield.dart';
import '../component/utils.dart';
import '../main.dart';
import 'rooms_list_page.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      scaffoldMessengerKey: Utils2.messengerKey2,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: formkey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: h * .1),
                    Image.asset(
                      'assets/images/logo.png',
                      width: w * .5,
                      height: w * .5,
                    ),
                    SizedBox(height: h * .05),
                    CustomTextField(
                      text: 'Name',
                      icon: FontAwesomeIcons.solidUser,
                      hide: false,
                      controller: nameController,
                      validator: (name) => name != null && name.length < 3
                          ? 'Enter a name'
                          : name!.length > 40
                              ? 'name should be less than 40 char'
                              : null,
                    ),
                    SizedBox(height: h * .027),
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
                    SizedBox(height: h * .027),
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
                    SizedBox(height: h * .05),
                    CustomButton(
                      text: 'Register',
                      onPressed: () {
                        register();
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have account?',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.white,
                          )),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
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
                    SizedBox(
                      height: h * .1,
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future register() async {
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) => add());
    } on FirebaseAuthException catch (e) {
      Utils2.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WorldsList()));
  }

  add() {
    final user = FirebaseAuth.instance.currentUser;
    user!.updateDisplayName(nameController.text.trim());
    Navigator.pop(context);
  }
}
