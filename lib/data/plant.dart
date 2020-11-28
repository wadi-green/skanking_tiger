import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'activity_category.dart';

@immutable
class Plant extends Equatable {
  final String id;
  final String name;
  final ActivityCategory category;
  final String image;
  final String description;

  /// how matured the plant is in days (will grow overtime)
  final int age;

  /// which version of the plant this is
  final int revision;

  const Plant({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.image,
    @required this.age,
    @required this.revision,
    @required this.description,
  });

  @override
  List<Object> get props => [id];

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        category: ActivityCategory.fromJson(
          json['category'] as Map<String, dynamic>,
        ),
        image: json['image'] as String,
        age: json['age'] as int,
        revision: json['revision'] as int,
      );
}
