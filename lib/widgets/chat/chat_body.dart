import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../data/message.dart';
import '../../data/planter.dart';
import '../../models/auth_model.dart';
import '../../models/messages_provider.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/strings.dart';
import 'chat_bubble.dart';

/// The chat body page has a bit of a complex structure due to the fact that it
/// needs to parse the messages and display data depending on certain conditions.
/// To make it easier to follow and debug, I divided it into chunks of smaller
/// processes:
/// 1. Parse the messages and group them by date, then build each section (day)
///     on its own
/// 2. For each day, go over the messages iteratively with the following process:
///     a. While the messages belong to the same user, keep going
///     b. Once you hit the end of the user's messages, build that section
///     c. Keep proceeding until all messages are built
class ChatBody extends StatelessWidget {
  final VoidCallback onRefresh;

  const ChatBody({Key key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagesProvider = context.watch<MessagesProvider>();
    final messages = messagesProvider.messages;
    if (messages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            Strings.noMessagesYet,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    }
    final currentUser =
        context.select<AuthModel, Planter>((model) => model.user);
    final groupedMessages = groupMessagesByDate(messages);
    // The chat list is reversed, meaning that it scrolls from bottom to top.
    // That's why we need to reverse the days order
    final availableDates = groupedMessages.keys.toList().reversed.toList();
    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        reverse: true,
        itemCount: availableDates.length,
        itemBuilder: (context, i) {
          final date = availableDates[i];
          return buildMessagesGroup(
            currentUser,
            messagesProvider.otherUserAvatar,
            date,
            groupedMessages[date],
          );
        },
      ),
    );
  }

  /// Step 1: Group the messages by date to separate them into smaller sections
  Map<DateTime, List<Message>> groupMessagesByDate(List<Message> messages) {
    final result = <DateTime, List<Message>>{};
    for (final message in messages) {
      if (result.containsKey(message.dateTime.toDateOnly)) {
        result[message.dateTime.toDateOnly].add(message);
      } else {
        result[message.dateTime.toDateOnly] = [message];
      }
    }
    return result;
  }

  /// Step 2. Build each day messages as a standalone section
  Widget buildMessagesGroup(Planter currentUser, String otherUserAvatar,
      DateTime date, List<Message> messages) {
    final formatter = DateFormat('dd MMM, yyyy');
    final children = <Widget>[];
    for (var i = 0; i < messages.length; i++) {
      final firstMessage = messages[i];
      final isSender = firstMessage.author == currentUser.fullName;
      final allUserMessages = <Message>[];
      // Collect all the current user messages
      while (i < messages.length && messages[i].author == firstMessage.author) {
        allUserMessages.add(messages[i]);
        i++;
      }
      // Reverse the last increment since it will be done by the outer for loop
      i--;
      children.add(buildSingleUserMessages(
        allUserMessages,
        isSender ? currentUser.picture : otherUserAvatar,
        isSender: isSender,
      ));
      children.add(const SizedBox(height: 12));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            formatter.format(date),
            style: const TextStyle(color: MainColors.darkGrey),
          ),
        ),
        ...children,
      ],
    );
  }

  /// Step 3: After collecting the user's messages, build them as a standalone
  /// section too
  Widget buildSingleUserMessages(List<Message> messages, String imageUrl,
      {bool isSender}) {
    final formatter = DateFormat('HH:mm');
    // When the duration between two messages is less than this value, the
    // time for the earlier message won't be printed
    const allowedDurationWithoutDate = Duration(minutes: 1);
    final children = <Widget>[];
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      children.add(ChatBubble(body: message.message, isSender: isSender));
      final messageTime = Container(
        padding: const EdgeInsets.all(4),
        alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
        child: Text(
          formatter.format(message.dateTime),
          style: const TextStyle(color: MainColors.darkGrey, fontSize: 13),
        ),
      );
      if (i == messages.length - 1) {
        // This is the last message, always add the time here
        children.add(messageTime);
      } else if (messages[i + 1].dateTime.difference(message.dateTime) <
          allowedDurationWithoutDate) {
        // Less than one minute has passed. Don't put a time
        children.add(const SizedBox(height: 4));
      } else {
        // More than one minute has passed, print the time
        children.add(messageTime);
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
          )
        else
          const SizedBox(width: 48),
        Flexible(child: Column(children: children)),
        if (isSender)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }
}
