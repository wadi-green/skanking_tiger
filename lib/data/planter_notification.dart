import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class PlanterNotification extends Equatable {
  final String title;
  final String message;
  final DateTime time;
  final String icon;

  PlanterNotification({
    this.title,
    this.message,
    String time,
    this.icon,
  }) : time = DateTime.tryParse(time);

  @override
  List<Object> get props => [title, message, time];

  factory PlanterNotification.fromJson(Map<String, dynamic> json) =>
      PlanterNotification(
        title: json['title'] as String,
        message: json['message'] as String,
        time: json['time'] as String,
        icon: json['icon'] as String,
      );

  String get timeFormatted => DateFormat('HH:mm, MMM dd').format(time);

  IconData get iconData {
    switch (icon) {
      case 'like':
        return Icons.thumb_up_outlined;
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
}
