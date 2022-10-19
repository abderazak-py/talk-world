import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk_world/component/custom_button.dart';
import 'package:talk_world/component/custom_textfield.dart';
import 'package:talk_world/component/user_info.dart';
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
  final ImagePicker _picker = ImagePicker();
  bool editMode = false;

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
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: editMode
              ? Form(
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
                            Container(
                              width: w * .4,
                              height: w * .4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    image: (user!.photoURL == null)
                                        ? AssetImage(
                                            'assets/images/logo.png',
                                          )
                                        : NetworkImage(user!.photoURL!)
                                            as ImageProvider,
                                  )),
                            ),
                            TextButton(
                                onPressed: () async {
                                  XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    final file = File(image.path);
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    final path =
                                        'files/ProfileImages/${user?.email}/${image.name}';
                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child(path);
                                    UploadTask? uploadTask;
                                    uploadTask = ref.putFile(file);
                                    final snapshot =
                                        await uploadTask.whenComplete(() {});
                                    final urlDownload =
                                        await snapshot.ref.getDownloadURL();
                                    user?.updatePhotoURL(urlDownload);
                                    setState(() {
                                      editMode = false;
                                    });
                                  }
                                },
                                child: Text(
                                  'Change Photo',
                                  style: GoogleFonts.lato(
                                      color: kBlueColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
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
                                setState(() {
                                  editMode = false;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    editMode = false;
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Form(
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
                            Container(
                              width: w * .4,
                              height: w * .4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    image: (user!.photoURL == null)
                                        ? AssetImage(
                                            'assets/images/logo.png',
                                          )
                                        : NetworkImage(user!.photoURL!)
                                            as ImageProvider,
                                  )),
                            ),
                            SizedBox(height: h * .04),
                            UserInfoCard(
                                info: user!.displayName!,
                                icon: FontAwesomeIcons.solidUser),
                            SizedBox(height: h * .04),
                            UserInfoCard(
                                info: user!.email!,
                                icon: FontAwesomeIcons.solidEnvelope),
                            SizedBox(height: h * .04),
                            UserInfoCard(
                                info: '****************',
                                icon: FontAwesomeIcons.lock),
                            SizedBox(height: h * .1),
                            CustomButton(
                              text: 'Edit',
                              onPressed: () {
                                setState(() {
                                  editMode = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
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
