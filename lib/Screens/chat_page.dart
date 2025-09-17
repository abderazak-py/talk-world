import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talk_world/component/image_message.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../component/consts.dart';
import '../component/custom_app_bar.dart';
import '../component/send_message_text_field.dart';
import '../component/send_voice_message.dart';
import '../component/show_date.dart';
import '../component/show_sender_name.dart';
import '../component/show_sender_photo.dart';
import '../component/space_before_message.dart';
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
                        CustomAppBar(),
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
                                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                      ],
                                    );
                                  }
                                } else {
                                  if ((messagesList[index].type == 'image')) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ShowSenderName(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SpaceBeforeMessage(
                                                index: index,
                                                messagesList: messagesList),
                                            ShowSenderPhoto(
                                                index: index,
                                                messagesList: messagesList),
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                      ],
                                    );
                                  } else if (messagesList[index].type ==
                                      'text') {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShowSenderName(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                        Row(
                                          children: [
                                            SpaceBeforeMessage(
                                                index: index,
                                                messagesList: messagesList),
                                            ShowSenderPhoto(
                                                index: index,
                                                messagesList: messagesList),
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShowSenderName(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                        Row(
                                          children: [
                                            SpaceBeforeMessage(
                                                index: index,
                                                messagesList: messagesList),
                                            ShowSenderPhoto(
                                                index: index,
                                                messagesList: messagesList),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 17,
                                                 // right: 150,
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
                                        ShowDate(
                                          index: index,
                                          messagesList: messagesList,
                                        ),
                                      ],
                                    );
                                  }
                                }
                              }),
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            SendMessageTextField(
                                messages: messages,
                                collection: widget.collection),
                            SendVoiceMessage(messages: messages),
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
