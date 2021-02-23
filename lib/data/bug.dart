import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Bug extends Equatable {
  final String id;
  final String title;
  final String description;

  const Bug({
    @required this.id,
    @required this.title,
    @required this.description,
  });

  @override
  List<Object> get props => [id];

  factory Bug.fromJson(Map<String, dynamic> json) => Bug(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
      );
}
