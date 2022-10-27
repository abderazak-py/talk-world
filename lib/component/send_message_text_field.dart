import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'consts.dart';

class SendMessageTextField extends StatelessWidget {
  const SendMessageTextField(
      {super.key, required this.messages, required this.collection});
  final CollectionReference<Map<String, dynamic>> messages;
  final String collection;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final ImagePicker picker = ImagePicker();
    final messageController = TextEditingController();
    final scroolController = ScrollController();

    return TextField(
      controller: messageController,
      onSubmitted: (data) async {
        if (messageController.text.trim() != '' &&
            messageController.text.trim() != '') {
          final user = FirebaseAuth.instance.currentUser;
          bool result = await InternetConnectionChecker().hasConnection;
          if (result == true) {
            messages.add(
              {
                'message': messageController.text,
                'date': DateTime.now(),
                'id': user!.email,
                'name': user.displayName,
                'uid': user.uid,
                'type': 'text',
                'profilePhoto': user.photoURL,
              },
            );
            messageController.clear();
          } else {
            if (!mounted) return;
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message:
                    "Oh! There's no internet connection. Please check your internet and try again",
              ),
            );
          }

          scroolController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        }
      },
      style: GoogleFonts.lato(
          textStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: kBlackColor,
      )),
      cursorColor: kSuperGreyColor,
      cursorHeight: 25,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20, top: 19.5, bottom: 19.5),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: kGreyColor,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreyColor),
            borderRadius: BorderRadius.zero),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreyColor),
            borderRadius: BorderRadius.zero),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreyColor),
            borderRadius: BorderRadius.zero),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreyColor),
            borderRadius: BorderRadius.zero),
        labelText: 'Type... in $collection',
        labelStyle: GoogleFonts.lato(
            fontSize: 20, color: kSuperGreyColor, fontWeight: FontWeight.w800),
        hintText: 'Type... in $collection',
        hintStyle: GoogleFonts.lato(
            fontSize: 20, color: kSuperGreyColor, fontWeight: FontWeight.w800),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                bool result = await InternetConnectionChecker().hasConnection;
                if (result == true) {
                  XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final file = File(image.path);
                    final user = FirebaseAuth.instance.currentUser;
                    final path = 'files/images/${user!.email}/${image.name}';
                    final ref = FirebaseStorage.instance.ref().child(path);
                    UploadTask? uploadTask;
                    uploadTask = ref.putFile(file);
                    final snapshot = await uploadTask.whenComplete(() {});
                    final urlDownload = await snapshot.ref.getDownloadURL();
                    messages.add(
                      {
                        'message': urlDownload,
                        'date': DateTime.now(),
                        'id': user.email,
                        'name': user.displayName,
                        'uid': user.uid,
                        'type': 'image',
                        'profilePhoto': user.photoURL,
                      },
                    );
                  }
                } else {
                  if (!mounted) return;
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                          "Oh! There's no internet connection. Please check your internet and try again",
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.image,
                color: kSuperGreyColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (messageController.text.trim() != '' &&
                    messageController.text.trim() != '') {
                  final user = FirebaseAuth.instance.currentUser;
                  bool result = await InternetConnectionChecker().hasConnection;
                  if (result == true) {
                    messages.add(
                      {
                        'message': messageController.text,
                        'date': DateTime.now(),
                        'id': user!.email,
                        'name': user.displayName,
                        'uid': user.uid,
                        'type': 'text',
                        'profilePhoto': user.photoURL,
                      },
                    );
                    messageController.clear();
                  } else {
                    if (!mounted) return;
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                            "Oh! There's no internet connection. Please check your internet and try again",
                      ),
                    );
                  }
                  scroolController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                }
              },
              icon: Icon(
                Icons.send_rounded,
                color: kSuperGreyColor,
              ),
            ),
            SizedBox(width: 35),
          ],
        ),
      ),
    );
  }
}
