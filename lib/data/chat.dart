import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'planter.dart';

@immutable
class Chat extends Equatable {
  final String chatGroupId;
  final String friendName;
  final String friendAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;

  const Chat({
    @required this.chatGroupId,
    @required this.friendName,
    @required this.friendAvatar,
    this.lastMessage,
    this.lastMessageTime,
  });

  @override
  List<Object> get props => [chatGroupId];

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatGroupId: json['chatGroupId'] as String,
        friendName: json['friendName'] as String,
        friendAvatar: json['friendAvatar'] as String,
        lastMessage: json['lastMessage'] as String,
        lastMessageTime: DateTime.tryParse(json['lastMessageTime'] as String),
      );

  Chat.fromPlanter(Planter planter)
      : chatGroupId = planter.id,
        friendName = planter.fullName,
        friendAvatar = planter.picture,
        lastMessage = null,
        lastMessageTime = null;
}
