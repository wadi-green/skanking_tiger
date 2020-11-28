import 'package:flutter/material.dart';

@immutable
class ActivityBenefit {
  final String description;
  final String category;

  const ActivityBenefit({
    @required this.description,
    @required this.category,
  });

  factory ActivityBenefit.fromJson(Map<String, dynamic> json) =>
      ActivityBenefit(
        description: json['description'] as String,
        category: json['category'] as String,
      );

  IconData get iconData {
    switch (category) {
      case 'car':
        return Icons.electric_car;
      case 'help':
        return Icons.help_outline_outlined;
      case 'travel':
        return Icons.flight;
      case 'sport':
        return Icons.sports;
      default:
        return Icons.autorenew;
    }
  }
}
