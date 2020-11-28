import 'package:flutter/material.dart';

import '../../data/chat.dart';
import '../../screens/messenger_chat_screen.dart';

/// A modal route that slides from right to left and covers 85% of the screen
/// width
class MessengerChatRoute extends ModalRoute<void> {
  final Chat chat;

  MessengerChatRoute(this.chat);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black45;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: GestureDetector(
          // Closes the chat when the user swipes right. Increase the delta
          // value to make the user swipe longer before dismissing
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10) {
              Navigator.pop(context);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) => Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * 0.15),
              child: MessengerChatScreen(chat: chat),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
