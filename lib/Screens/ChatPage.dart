import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/consts.dart';
import '../models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final _messageController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  final messages = FirebaseFirestore.instance.collection(kMessagesCollections);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return MaterialApp(
            home: Scaffold(
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
                              backgroundImage:
                                  AssetImage('assets/images/miniLogo.png'),
                              backgroundColor: Colors.white,
                              radius: 19,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, profilePageRoute);
                              },
                              child: Text(
                                'My Profile',
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: kBlackColor,
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
                              return messagesList[index].uid == user!.uid
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      actionsPadding: EdgeInsets.all(8),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      title: Text(
                                                          'Message information',
                                                          style: GoogleFonts.lato(
                                                              color:
                                                                  kBlackColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      content: Text(
                                                        'Sender: ${messagesList[index].name}\n\nDate: ${messagesList[index].date.toDate().toLocal()}\n\nEmail: ${messagesList[index].id}',
                                                        style: GoogleFonts.lato(
                                                            color: kBlackColor,
                                                            fontSize: 18),
                                                      ),
                                                    ));
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
                                        Visibility(
                                          visible: (index == 0)
                                              ? true
                                              : (messagesList[index].uid ==
                                                      messagesList[index - 1]
                                                          .uid)
                                                  ? false
                                                  : true,
                                          child: Center(
                                            child: Text(
                                              '${messagesList[index].date.toDate().toLocal().hour}:${messagesList[index].date.toDate().toLocal().minute}',
                                              style: GoogleFonts.lato(
                                                  color: kSuperGreyColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: (index ==
                                                  messagesList.length - 1)
                                              ? true
                                              : (messagesList[index].uid ==
                                                      messagesList[index + 1]
                                                          .uid)
                                                  ? false
                                                  : true,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 24),
                                            child: Text(
                                              messagesList[index].name,
                                              style: GoogleFonts.lato(
                                                  color: kSuperGreyColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      actionsPadding: EdgeInsets.all(8),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      title: Text(
                                                          'Message information',
                                                          style: GoogleFonts.lato(
                                                              color:
                                                                  kBlackColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      content: Text(
                                                        'Sender: ${messagesList[index].name}\n\nDate: ${messagesList[index].date.toDate().toLocal()}\n\nEmail: ${messagesList[index].id}',
                                                        style: GoogleFonts.lato(
                                                            color: kBlackColor,
                                                            fontSize: 18),
                                                      ),
                                                    ));
                                          },
                                          child: BubbleSpecialThree(
                                            text: messagesList[index].message,
                                            color: Color(0xFFE8E8EE),
                                            tail: (index == 0)
                                                ? true
                                                : (messagesList[index].uid ==
                                                        messagesList[index - 1]
                                                            .uid)
                                                    ? false
                                                    : true,
                                            isSender: false,
                                            textStyle: GoogleFonts.lato(
                                                color: kBlackColor,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (index == 0)
                                              ? true
                                              : (messagesList[index].uid ==
                                                      messagesList[index - 1]
                                                          .uid)
                                                  ? false
                                                  : true,
                                          child: Center(
                                            child: Text(
                                              '${messagesList[index].date.toDate().toLocal().hour}:${messagesList[index].date.toDate().toLocal().minute}',
                                              style: GoogleFonts.lato(
                                                  color: kSuperGreyColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextField(
                          controller: messageController,
                          onSubmitted: (data) {
                            sendMessage();
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
                            contentPadding:
                                EdgeInsets.only(left: 33, top: 20, bottom: 20),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: kGreyColor,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyColor),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyColor),
                                borderRadius: BorderRadius.circular(15)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyColor),
                                borderRadius: BorderRadius.circular(15)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyColor),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Type...',
                            labelStyle: GoogleFonts.lato(
                                fontSize: 20,
                                color: kSuperGreyColor,
                                fontWeight: FontWeight.w800),
                            hintText: 'Type...',
                            hintStyle: GoogleFonts.lato(
                                fontSize: 20,
                                color: kSuperGreyColor,
                                fontWeight: FontWeight.w800),
                            suffixIcon: IconButton(
                              onPressed: () {
                                sendMessage();
                              },
                              icon: Icon(
                                Icons.send_rounded,
                                color: kSuperGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  sendMessage() {
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
        },
      );
      messageController.clear();
      _messageController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }
}
