import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/consts.dart';
import '../models/message.dart';

class ShowDate extends StatelessWidget {
  const ShowDate({
    super.key, required this.messagesList, required this.index,
  });
  final List<Message> messagesList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (index == 0)
          ? true
          : (messagesList[index].uid == messagesList[index - 1].uid)
              ? false
              : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: (index == 0)
            ? Center(
                child: DateChip(
                  date: messagesList[index].date.toDate().toLocal(),
                  color: kGreyColor,
                ),
              )
            : (messagesList[index].date.toDate().toLocal().day ==
                    messagesList[index - 1].date.toDate().toLocal().day)
                ? Center(
                    child: Text(
                      '${messagesList[index].date.toDate().toLocal().hour}:${messagesList[index].date.toDate().toLocal().minute}',
                      style: GoogleFonts.lato(
                          color: kSuperGreyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Center(
                    child: DateChip(
                      date: messagesList[index].date.toDate().toLocal(),
                      color: kGreyColor,
                    ),
                  ),
      ),
    );
  }
}