import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Bug extends Equatable {
  final String title;
  final String description;

  const Bug({
    @required this.title,
    @required this.description,
  });

  @override
  List<Object> get props => [title];

  factory Bug.fromJson(Map<String, dynamic> json) => Bug(
        title: json['title'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
