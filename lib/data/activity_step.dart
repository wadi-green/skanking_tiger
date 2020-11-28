import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Steps to finish an activity
@immutable
class ActivityStep extends Equatable {
  /// Which ordered step it is
  final int number;

  /// How much karma this step has particularly
  final int karma;

  /// What is the step asking you to do
  final String description;
  final String icon;

  const ActivityStep({
    @required this.number,
    @required this.karma,
    @required this.description,
    @required this.icon,
  });

  @override
  List<Object> get props => [number, karma, description];

  IconData get iconData {
    switch (icon) {
      case 'bike':
        return Icons.directions_bike_outlined;
      case 'help':
        return Icons.help_outline_outlined;
      case 'cut':
        return Icons.content_cut_outlined;
      case 'save':
        return Icons.save_alt_outlined;
      case 'play':
        return Icons.play_circle_outline_outlined;
      case 'pin':
        return Icons.push_pin_outlined;
      default:
        return Icons.autorenew;
    }
  }

  factory ActivityStep.fromJson(Map<String, dynamic> json) => ActivityStep(
        number: json['number'] as int,
        karma: json['karma'] as int,
        description: json['description'] as String,
        icon: json['icon'] as String,
      );
}
