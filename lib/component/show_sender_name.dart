import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/consts.dart';
import '../models/message.dart';

class ShowSenderName extends StatelessWidget {
  const ShowSenderName({
    super.key, required this.messagesList, required this.index,
  });
  final List<Message> messagesList;
  final int index;

  @override
  Widget build(BuildContext context) {
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
}