import 'package:flutter/material.dart';

@immutable
class ActivityCategory {
  final String name;
  final String image;

  const ActivityCategory({
    @required this.name,
    @required this.image,
  });

  factory ActivityCategory.fromJson(Map<String, dynamic> json) =>
      ActivityCategory(
        name: json['name'] as String,
        image: json['image'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}
