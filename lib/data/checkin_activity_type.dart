import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CheckInActivityType extends Equatable {
  static const activityProgressUpdate = 'ACTIVITY_PROGRESS_UPDATE';
  static const newActivityStarted = 'NEW_ACTIVITY_STARTED';
  static const finishedActivity = 'FINISHED_ACTIVITY';
  static const karmaGain = 'KARMA_GAIN';
  static const friendsAdd = 'FRIENDS_ADD';

  final String value;

  const CheckInActivityType(this.value);

  String get humanReadable {
    switch (value) {
      case activityProgressUpdate:
        return 'Activity progress update';
      case newActivityStarted:
        return 'Activity started';
      case finishedActivity:
        return 'Activity finished';
      case karmaGain:
        return 'Karma gain';
      case friendsAdd:
        return 'Friend added';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}
