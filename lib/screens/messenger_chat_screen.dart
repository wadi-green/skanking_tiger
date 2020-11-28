import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../data/chat.dart';
import '../data/message.dart';
import '../data/planter.dart';
import '../models/auth_model.dart';
import '../models/messages_provider.dart';
import '../utils/strings.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/chat/chat_body.dart';

class MessengerChatScreen extends StatefulWidget {
  final Chat chat;

  const MessengerChatScreen({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  _MessengerChatScreenState createState() => _MessengerChatScreenState();
}

class _MessengerChatScreenState extends State<MessengerChatScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messageController = TextEditingController();
  MessagesProvider _messagesProvider;
  Future<List<Message>> _messages;
  Planter currentUser;
  // When manually adding a message to the MessageProvider, it notifies its
  // listeners and this widget gets rebuilt. This causes the api results to
  // be re-injected into the messages provider and makes it lose the manually
  // added message. However, we don't always want to ignore the re-injected data
  // because there's a case where the user willingly refreshes the data. To take
  // this case into account, we use the forceRefresh value to force injecting
  // the messages from the future and override the ones in the provider
  bool _forceRefresh = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthModel>().user;
    _messagesProvider = MessagesProvider(widget.chat.friendAvatar);
    _messages = context
        .read<Api>()
        .fetchGroupMessages(currentUser.id, widget.chat.chatGroupId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messagesProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: MainColors.primary,
        title: Text(
          widget.chat.friendName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 12,
            backgroundImage:
                CachedNetworkImageProvider(widget.chat.friendAvatar),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AdvancedFutureBuilder<List<Message>>(
              future: _messages,
              builder: (messages) {
                if (_forceRefresh ||
                    _messagesProvider.messages.length < messages.length) {
                  _forceRefresh = false;
                  _messagesProvider.setMessages(messages);
                }
                return ChangeNotifierProvider.value(
                  value: _messagesProvider,
                  child: ChatBody(
                    onRefresh: () {
                      setState(() {
                        _forceRefresh = true;
                        _messages = context.read<Api>().fetchGroupMessages(
                            currentUser.id, widget.chat.chatGroupId);
                      });
                    },
                  ),
                );
              },
              onRefresh: () {
                setState(() {
                  _forceRefresh = true;
                  _messages = context.read<Api>().fetchGroupMessages(
                      currentUser.id, widget.chat.chatGroupId);
                });
              },
            ),
          ),
          buildMessageField(),
        ],
      ),
    );
  }

  Widget buildMessageField() => Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 16),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: Strings.message,
                    hintStyle: TextStyle(color: MainColors.grey),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MainColors.primary),
                    ),
                  ),
                ),
              )
            else
              IconButton(
                onPressed: submitMessage,
                color: MainColors.primary,
                icon: const Icon(Icons.send),
              ),
          ],
        ),
      );

  Future<void> submitMessage() async {
    if (_messageController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await context.read<Api>().sendMessageToGroup(
            Message(
              message: _messageController.text,
              author: currentUser.fullName,
              dateTime: DateTime.now(),
            ),
            currentUser.id,
            widget.chat.chatGroupId,
          );
      _messageController.clear();
      _messagesProvider.addMessage(response);
    } catch (e) {
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _isLoading = false);
  }
}
