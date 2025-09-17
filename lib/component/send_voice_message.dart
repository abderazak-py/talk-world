import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../component/consts.dart';

class SendVoiceMessage extends StatelessWidget {
  const SendVoiceMessage({
    super.key,
    required this.messages,
  });

  final CollectionReference<Map<String, dynamic>> messages;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return FutureBuilder<Directory?>(
        future: getTemporaryDirectory(),
        builder: (context, AsyncSnapshot<Directory?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SocialMediaRecorder(
              storeSoundRecoringPath: '${snapshot.data?.path}',
              sendRequestFunction: (soundFile) async {
                bool result = await InternetConnectionChecker().hasConnection;
                if (result == true) {
                  final file = File(soundFile.path);
                  final user = FirebaseAuth.instance.currentUser;
                  final path =
                      'files/sounds/${user!.email}/${DateTime.now().toLocal().day}-${DateTime.now().toLocal().hour}-${DateTime.now().toLocal().minute}';
                  final ref = FirebaseStorage.instance.ref().child(path);
                  UploadTask? uploadTask;
                  uploadTask = ref.putFile(file);
                  final snapshot = await uploadTask.whenComplete(() {});
                  final urlDownload = await snapshot.ref.getDownloadURL();
                  messages.add(
                    {
                      'message': urlDownload,
                      'date': DateTime.now().toUtc(),
                      'id': user.email,
                      'name': user.displayName,
                      'uid': user.uid,
                      'type': 'voice',
                      'profilePhoto': user.photoURL,
                    },
                  );
                } else {
                  if (!mounted) return;
                  showTopSnackBar(
                    context as OverlayState,
                    CustomSnackBar.error(
                      message:
                          "Oh! There's no internet connection. Please check your internet and try again",
                    ),
                  );
                }
              },
              encode: AudioEncoderType.AMR_NB,
              recordIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.keyboard_voice,
                  color: kSuperGreyColor,
                ),
              ),
              recordIconWhenLockedRecord: Icon(
                Icons.check,
                color: kBlackColor,
              ),
              backGroundColor: kGreyColor,
              recordIconBackGroundColor: Colors.red,
              counterBackGroundColor: kGreyColor,
              recordIconWhenLockBackGroundColor: kGreyColor,
              cancelTextBackGroundColor: kGreyColor,
              lockButton: Icon(Icons.lock),
            );
          } else {
            return Container();
          }
        });
  }
}
