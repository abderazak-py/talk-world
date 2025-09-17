import 'package:flutter/material.dart';
import '../models/message.dart';

class SpaceBeforeMessage extends StatelessWidget {
  const SpaceBeforeMessage({
    super.key, required this.index, required this.messagesList,
  });
  final int index;
  final List<Message> messagesList;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !((index == 0)
            ? true
            : (messagesList[index].uid == messagesList[index - 1].uid)
                ? false
                : true),
        child: SizedBox(width: 35));
  }
}
