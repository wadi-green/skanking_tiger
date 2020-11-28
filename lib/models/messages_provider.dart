import 'package:flutter/material.dart';

import '../data/message.dart';

class MessagesProvider extends ChangeNotifier {
  final String otherUserAvatar;
  final List<Message> messages = [];

  MessagesProvider(this.otherUserAvatar);

  void setMessages(List<Message> messages) {
    this.messages.clear();
    this.messages.addAll(messages);
    notifyListeners();
  }

  void addMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }
}
