import 'package:flutter/material.dart';

import '../easiness.dart';
import '../planter_checkin.dart';
import 'activity.dart';
import 'base_activity.dart';

/// The current state of activities that the planter is participating in
@immutable
class PlanterActivity extends BaseActivity {
  // how far along completion is this activity in percentage
  final int completedSteps;
  // whether the activity is finished or not
  final bool isComplete;

  const PlanterActivity({
    @required String activityId,
    @required String activityTitle,
    @required String activityImage,
    @required String shortDescription,
    @required Easiness activityEase,
    @required int activityLikes,
    @required this.completedSteps,
    @required this.isComplete,
  }) : super(
          id: activityId,
          image: activityImage,
          title: activityTitle,
          shortDescription: shortDescription,
          likes: activityLikes,
          ease: activityEase,
        );

  @override
  List<Object> get props => [id, completedSteps];

  factory PlanterActivity.fromNewActivity(Activity activity) => PlanterActivity(
        activityId: activity.id,
        activityTitle: activity.title,
        activityImage: activity.image,
        shortDescription: activity.shortDescription,
        completedSteps: 0,
        isComplete: false,
        activityEase: activity.ease,
        activityLikes: activity.likes,
      );

  factory PlanterActivity.fromCheckin({
    @required Activity activity,
    @required PlanterCheckIn checkIn,
  }) =>
      PlanterActivity(
        activityId: checkIn.activityId,
        activityTitle: checkIn.activityTitle,
        activityImage: activity.image,
        shortDescription: activity.shortDescription,
        completedSteps: checkIn.activityStep,
        isComplete: checkIn.activityStep == activity.totalSteps,
        activityEase: activity.ease,
        activityLikes: activity.likes,
      );

  factory PlanterActivity.fromJson(Map<String, dynamic> json) =>
      PlanterActivity(
        activityId: json['activityId'] as String,
        activityTitle: json['activityTitle'] as String,
        activityImage: json['activityImage'] as String,
        shortDescription: json['shortDescription'] as String,
        completedSteps: json['completedSteps'] as int,
        isComplete: json['isComplete'] as bool,
        activityEase: Easiness(json['activityEase'] as String),
        activityLikes: json['activityLikes'] as int,
      );
}
