import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String message;
  final String author;
  final DateTime dateTime;

  const Message({this.message, this.author, this.dateTime});

  @override
  List<Object> get props => [message, author, dateTime];

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json['message'] as String,
        author: json['author'] as String,
        dateTime: DateTime.tryParse(json['time'] as String ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'author': author,
        'time': dateTime.toIso8601String(),
      };
}
