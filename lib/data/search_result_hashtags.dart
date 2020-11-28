import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SearchResultHashtags extends Equatable {
  final List<String> related;
  final List<String> popular;

  const SearchResultHashtags({
    @required this.related,
    @required this.popular,
  });

  factory SearchResultHashtags.fromJson(Map<String, dynamic> json) =>
      SearchResultHashtags(
        related: List<String>.from(json['related'] as List),
        popular: List<String>.from(json['popular'] as List),
      );

  @override
  List<Object> get props => [related, popular];
}
