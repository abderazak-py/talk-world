import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/custom_button.dart';
import 'package:talk_world/component/custom_textfield.dart';

import '../component/Utils.dart';
import '../component/consts.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

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
      scaffoldMessengerKey: Utils4.messengerKey4,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: formkey,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 30),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.circleLeft,
                                        color: kBlueColor, size: 20),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Back',
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: kBlueColor,
                                      )),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          width: w * .4,
                          height: w * .4,
                        ),
                        SizedBox(height: h * .04),
                        CustomTextField(
                          text: 'Change your name',
                          icon: FontAwesomeIcons.solidUser,
                          hide: false,
                          controller: nameController,
                          validator: (name) =>
                              name!.isNotEmpty && name.trim().length < 3
                                  ? 'Enter a name'
                                  : null,
                        ),
                        SizedBox(height: h * .04),
                        CustomTextField(
                          text: 'Change email',
                          icon: FontAwesomeIcons.solidEnvelope,
                          hide: false,
                          controller: emailController,
                          validator: (email) => email!.isNotEmpty &&
                                  !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                        ),
                        SizedBox(height: h * .04),
                        CustomTextField(
                          text: 'Change password',
                          icon: FontAwesomeIcons.lock,
                          hide: true,
                          controller: passwordController,
                          validator: (password) =>
                              password!.isNotEmpty && password.length < 6
                                  ? 'Enter min. 6 characters'
                                  : null,
                        ),
                        SizedBox(height: h * .1),
                        CustomButton(
                          text: 'Update',
                          onPressed: () {
                            update();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future update() async {
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
      if (nameController.text.trim().isNotEmpty) {
        await user!.updateDisplayName(nameController.text.trim());
        Utils4.showSnackBar(
            'your new name is ${nameController.text.trim()}', Colors.green);
        nameController.clear();
      }
      if (emailController.text.trim().isNotEmpty) {
        await user!.updateEmail(emailController.text.trim());
        Utils4.showSnackBar(
            'your new email is ${emailController.text.trim()}', Colors.green);
        emailController.clear();
      }
      if (passwordController.text.isNotEmpty) {
        await user!.updatePassword(passwordController.text);
        Utils4.showSnackBar('Password Changed', Colors.green);
        passwordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      Utils4.showSnackBar(e.message, Colors.red);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
