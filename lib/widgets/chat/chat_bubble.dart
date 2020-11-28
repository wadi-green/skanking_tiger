import 'package:flutter/material.dart';

import '../../core/colors.dart';
import 'chat_bubble_clipper.dart';

class ChatBubble extends StatelessWidget {
  final String body;
  final bool isSender;

  const ChatBubble({
    Key key,
    @required this.body,
    this.isSender = false,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.zero,
      child: PhysicalShape(
        clipper: ChatBubbleClipper(isSender: isSender),
        color: MainColors.darkGrey,
        shadowColor: Colors.grey.shade200,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(body, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
