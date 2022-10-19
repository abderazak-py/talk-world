import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:talk_world/Screens/ProfilePage.dart';
import 'package:talk_world/component/image_message.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../component/consts.dart';
import '../models/message.dart';

class ChatPage extends StatefulWidget {
  final String collection;

  const ChatPage({Key? key, required this.collection}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final _messageController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final messages = FirebaseFirestore.instance.collection(widget.collection);
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return MaterialApp(
            home: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 30),
                            CircleAvatar(
                              backgroundColor: kSuperGreyColor,
                              radius: 20,
                              child: CircleAvatar(
                                backgroundImage: (user!.photoURL == null)
                                    ? AssetImage(
                                        'assets/images/logo.png',
                                      )
                                    : NetworkImage(user!.photoURL!)
                                        as ImageProvider,
                                backgroundColor: Colors.white,
                                radius: 19,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()));
                                },
                                child: Text(
                                  'My Profile',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )),
                            Spacer(),
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                child: Text(
                                  'SignOut',
                                  style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(width: 30),
                          ],
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                              reverse: true,
                              controller: _messageController,
                              itemCount: messagesList.length,
                              itemBuilder: (context, index) {
                                if (messagesList[index].uid == user!.uid) {
                                  if ((messagesList[index].type == 'image')) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            showMessageInformation(
                                                context, messagesList, index);
                                          },
                                          child: ImageMessage(
                                              isSender: true,
                                              imagePath:
                                                  messagesList[index].message),
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  } else if (messagesList[index].type ==
                                      'text') {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            showMessageInformation(
                                                context, messagesList, index);
                                          },
                                          child: BubbleSpecialThree(
                                            text: messagesList[index].message,
                                            color: Color(0xFF1B97F3),
                                            tail: (index == 0)
                                                ? true
                                                : (messagesList[index - 1]
                                                            .uid ==
                                                        user?.uid)
                                                    ? false
                                                    : true,
                                            isSender: true,
                                            textStyle: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 190, bottom: 5),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              showMessageInformation(
                                                  context, messagesList, index);
                                            },
                                            child: VoiceMessage(
                                              meBgColor: Color(0xFF1B97F3),
                                              audioSrc:
                                                  messagesList[index].message,
                                              me: true,
                                            ),
                                          ),
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  }
                                } else {
                                  if ((messagesList[index].type == 'image')) {
                                    return Column(
                                      children: [
                                        showName(index, messagesList),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            spaceBeforeMessage(
                                                index, messagesList),
                                            showSenderPhoto(
                                                index, messagesList, 18),
                                            GestureDetector(
                                              onLongPress: () {
                                                showMessageInformation(context,
                                                    messagesList, index);
                                              },
                                              child: ImageMessage(
                                                  isSender: false,
                                                  imagePath: messagesList[index]
                                                      .message),
                                            ),
                                          ],
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  } else if (messagesList[index].type ==
                                      'text') {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        showName(index, messagesList),
                                        Row(
                                          children: [
                                            spaceBeforeMessage(
                                                index, messagesList),
                                            showSenderPhoto(
                                                index, messagesList, 18),
                                            GestureDetector(
                                              onLongPress: () {
                                                showMessageInformation(context,
                                                    messagesList, index);
                                              },
                                              child: BubbleSpecialThree(
                                                text:
                                                    messagesList[index].message,
                                                color: kWhiteColor,
                                                tail: (index == 0)
                                                    ? true
                                                    : (messagesList[index]
                                                                .uid ==
                                                            messagesList[
                                                                    index - 1]
                                                                .uid)
                                                        ? false
                                                        : true,
                                                isSender: false,
                                                textStyle: GoogleFonts.lato(
                                                    color: kBlackColor,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        showName(index, messagesList),
                                        Row(
                                          children: [
                                            spaceBeforeMessage(
                                                index, messagesList),
                                            showSenderPhoto(
                                                index, messagesList, 18),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 17,
                                                  right: 150,
                                                  bottom: 5),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  showMessageInformation(
                                                      context,
                                                      messagesList,
                                                      index);
                                                },
                                                child: VoiceMessage(
                                                  contactBgColor: kWhiteColor,
                                                  contactFgColor: kGreyColor,
                                                  contactPlayIconColor:
                                                      kSuperGreyColor,
                                                  audioSrc: messagesList[index]
                                                      .message,
                                                  me: false,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        showDate(index, messagesList),
                                      ],
                                    );
                                  }
                                }
                              }),
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            sendTextField(messages),
                            FutureBuilder<Directory?>(
                                future: getTemporaryDirectory(),
                                builder: (context,
                                    AsyncSnapshot<Directory?> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return SocialMediaRecorder(
                                      storeSoundRecoringPath:
                                          '${snapshot.data?.path}',
                                      sendRequestFunction: (soundFile) async {
                                        final file = File(soundFile.path);
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        final path =
                                            'files/sounds/${user!.email}/${DateTime.now().toLocal().day}-${DateTime.now().toLocal().hour}-${DateTime.now().toLocal().minute}';
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child(path);
                                        UploadTask? uploadTask;
                                        uploadTask = ref.putFile(file);
                                        final snapshot = await uploadTask
                                            .whenComplete(() {});
                                        final urlDownload =
                                            await snapshot.ref.getDownloadURL();
                                        messages.add(
                                          {
                                            'message': urlDownload,
                                            'date': DateTime.now(),
                                            'id': user.email,
                                            'name': user.displayName,
                                            'uid': user.uid,
                                            'type': 'voice',
                                            'profilePhoto': user.photoURL,
                                          },
                                        );
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
                                      recordIconWhenLockBackGroundColor:
                                          kGreyColor,
                                      cancelTextBackGroundColor: kGreyColor,
                                      lockButton: Icon(Icons.lock),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            )),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ),
          );
        }
      },
    );
  }

  spaceBeforeMessage(int index, List<Message> messagesList) {
    return Visibility(
        visible: !((index == 0)
            ? true
            : (messagesList[index].uid == messagesList[index - 1].uid)
                ? false
                : true),
        child: SizedBox(width: 25));
  }

  showSenderPhoto(int index, List<Message> messagesList, double? size) {
    return Visibility(
      visible: (index == 0)
          ? true
          : (messagesList[index].uid == messagesList[index - 1].uid)
              ? false
              : true,
      child: CircleAvatar(
        backgroundColor: kSuperGreyColor,
        radius: size,
        child: CircleAvatar(
          backgroundImage: (messagesList[index].profilePhoto == null ||
                  messagesList[index].profilePhoto == '')
              ? AssetImage(
                  'assets/images/miniLogo.png',
                )
              : NetworkImage(messagesList[index].profilePhoto!)
                  as ImageProvider,
          backgroundColor: Colors.white,
          radius: (size! - 1),
        ),
      ),
    );
  }

  sendTextField(CollectionReference<Map<String, dynamic>> messages) {
    return Flexible(
      child: TextField(
        controller: messageController,
        onSubmitted: (data) {
          if (messageController.text.trim() != '' &&
              messageController.text.trim() != '') {
            final user = FirebaseAuth.instance.currentUser;
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
            _messageController.animateTo(0,
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
          labelText: 'Type... in ${widget.collection}',
          labelStyle: GoogleFonts.lato(
              fontSize: 20,
              color: kSuperGreyColor,
              fontWeight: FontWeight.w800),
          hintText: 'Type... in ${widget.collection}',
          hintStyle: GoogleFonts.lato(
              fontSize: 20,
              color: kSuperGreyColor,
              fontWeight: FontWeight.w800),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
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
                    //image = null;
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
                    _messageController.animateTo(0,
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
      ),
    );
  }

  showDate(int index, List<Message> messagesList) {
    return Visibility(
      visible: (index == 0)
          ? true
          : (messagesList[index].uid == messagesList[index - 1].uid)
              ? false
              : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: (index == 0)
            ? DateChip(
                date: messagesList[index].date.toDate(),
                color: kWhiteColor,
              )
            : (messagesList[index].date.toDate().day ==
                    messagesList[index - 1].date.toDate().day)
                ? Center(
                    child: Text(
                      '${messagesList[index].date.toDate().toLocal().hour}:${messagesList[index].date.toDate().toLocal().minute}',
                      style: GoogleFonts.lato(
                          color: kSuperGreyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : DateChip(
                    date: messagesList[index].date.toDate(),
                    color: kWhiteColor,
                  ),
      ),
    );
  }

  showName(int index, List<Message> messagesList) {
    return Visibility(
      visible: (index == messagesList.length - 1)
          ? true
          : (messagesList[index].uid == messagesList[index + 1].uid)
              ? false
              : true,
      child: Padding(
        padding: const EdgeInsets.only(left: 55),
        child: Text(
          messagesList[index].name,
          style: GoogleFonts.lato(
              color: kSuperGreyColor,
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  showMessageInformation(
      BuildContext context, List<Message> messagesList, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsPadding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Center(
                child: Column(
                  children: [
                    Text('Message information',
                        style: GoogleFonts.lato(
                            color: kBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: kSuperGreyColor,
                        radius: 35,
                        child: CircleAvatar(
                          backgroundImage: (messagesList[index].profilePhoto ==
                                      null ||
                                  messagesList[index].profilePhoto == '')
                              ? AssetImage(
                                  'assets/images/miniLogo.png',
                                )
                              : NetworkImage(messagesList[index].profilePhoto!)
                                  as ImageProvider,
                          backgroundColor: Colors.white,
                          radius: (34),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => InteractiveViewer(
                            panEnabled: false,
                            boundaryMargin: EdgeInsets.all(100),
                            minScale: 0.5,
                            maxScale: 6,
                            child: CachedNetworkImage(
                              imageUrl:
                                  messagesList[index].profilePhoto!.toString(),
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/miniLogo.png'),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              content: Text(
                'Sender: ${messagesList[index].name}\n\nDate: ${messagesList[index].date.toDate().toLocal()}\n\nEmail: ${messagesList[index].id}',
                style: GoogleFonts.lato(color: kBlackColor, fontSize: 18),
              ),
            ));
  }
}

Future<String> getPath() async {
  Directory tempDir = await getTemporaryDirectory();
  return tempDir.path;
}
