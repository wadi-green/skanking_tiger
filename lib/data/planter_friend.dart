import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PlanterFriend extends Equatable {
  final String id;
  final String name;
  final String picture;
  final String recentActivity;

  const PlanterFriend({
    @required this.id,
    @required this.name,
    @required this.picture,
    @required this.recentActivity,
  });

  factory PlanterFriend.fromJson(Map<String, dynamic> json) => PlanterFriend(
        id: json['id'] as String,
        name: json['name'] as String,
        picture: json['picture'] as String,
        recentActivity: json['recentActivity'] as String,
      );

  @override
  List<Object> get props => [id];
}
