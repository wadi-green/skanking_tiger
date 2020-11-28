import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'checkin_activity_type.dart';

/// Dates on when an activity is logged by the planter
@immutable
class PlanterCheckIn extends Equatable {
  final String activityId;
  final String activityTitle;
  final int activityStep;
  final CheckInActivityType checkinType;
  final String timestamp;
  final String comment;
  final DateTime date;

  PlanterCheckIn({
    @required this.activityId,
    @required this.activityTitle,
    @required this.activityStep,
    @required this.checkinType,
    @required this.comment,
    @required this.timestamp,
  }) : date = DateTime.parse(timestamp);

  @override
  List<Object> get props => [activityId, checkinType, timestamp];

  String get dateFormatted => DateFormat('dd MMM, yyyy').format(date);

  factory PlanterCheckIn.fromJson(Map<String, dynamic> json) => PlanterCheckIn(
        activityId: json['activityId'] as String,
        checkinType: CheckInActivityType(json['checkinType'] as String),
        timestamp: json['timestamp'] as String,
        comment: json['comment'] as String,
        activityStep: json['activityStep'] as int,
        activityTitle: json['activityTitle'] as String,
      );

  Map<String, dynamic> toJson() => {
        'activityId': activityId,
        'activityTitle': activityTitle,
        'activityStep': activityStep,
        'checkinType': checkinType.value,
        'comment': comment,
        'timestamp': timestamp,
      };
}
