import 'package:flutter/material.dart';
import '../component/consts.dart';
import '../models/message.dart';


class ShowSenderPhoto extends StatelessWidget {
  const ShowSenderPhoto({
    super.key,
    required this.messagesList,
    required this.index,
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
      child: CircleAvatar(
        backgroundColor: kSuperGreyColor,
        radius: 18,
        child: CircleAvatar(
          backgroundImage: (messagesList[index].profilePhoto == null ||
                  messagesList[index].profilePhoto == '')
              ? AssetImage(
                  'assets/images/miniLogo.png',
                )
              : NetworkImage(messagesList[index].profilePhoto!)
                  as ImageProvider,
          backgroundColor: Colors.white,
          radius: (17),
        ),
      ),
    );
  }
}