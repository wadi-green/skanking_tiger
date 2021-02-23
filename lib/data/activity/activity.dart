import 'package:flutter/material.dart';

import '../activity_benefit.dart';
import '../activity_category.dart';
import '../activity_step.dart';
import '../easiness.dart';
import 'base_activity.dart';

@immutable
class Activity extends BaseActivity {
  final int followers;
  final int totalSteps;
  final String longDescription;
  // The steps that are required to be completed to finish this activity and gain karma
  final List<ActivityStep> steps;
  // A list of benefits that are gained (in the grand scheme of things)
  final List<ActivityBenefit> benefits;
  final List<String> externalLinks;
  // Which categories does this description lay in
  final List<ActivityCategory> categories;
  // if this activity is still search-able
  final bool active;
  // The amount of karma points you gain by doing this activity
  final int karma;
  // the target group for which this activity is intended for
  // final ActivityAudience audience;
  // the current revision number
  final int revision;

  const Activity({
    @required String id,
    @required String title,
    @required int likes,
    @required this.followers,
    @required String shortDescription,
    @required this.longDescription,
    @required this.steps,
    @required Easiness easiness,
    @required this.benefits,
    @required this.externalLinks,
    @required this.categories,
    @required this.active,
    @required this.karma,
    @required String imageUrl,
    // @required this.audience,
    @required this.revision,
    @required this.totalSteps,
  }) : super(
          id: id,
          image: imageUrl,
          title: title,
          shortDescription: shortDescription,
          likes: likes,
          ease: easiness,
        );

  @override
  List<Object> get props => [id];

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        title: json['title'] as String,
        likes: json['likes'] as int,
        followers: json['followers'] as int,
        shortDescription: json['shortDescription'] as String,
        longDescription: json['longDescription'] as String,
        steps: (json['steps'] as List ?? [])
            .map((e) => ActivityStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        easiness: Easiness(json['easiness'] as String),
        benefits: (json['benefits'] as List ?? [])
            .map((e) => ActivityBenefit.fromJson(e as Map<String, dynamic>))
            .toList(),
        externalLinks: List<String>.from(json['externalLinks'] as List),
        categories: (json['categories'] as List ?? [])
            .map((e) => ActivityCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
        active: json['active'] as bool,
        karma: json['karma'] as int,
        imageUrl: json['imageUrl'] as String,
        // audience:
        //     ActivityAudience.fromJson(json['audience'] as Map<String, dynamic>),
        revision: json['revision'] as int,
        totalSteps: json['totalSteps'] as int,
      );
}
