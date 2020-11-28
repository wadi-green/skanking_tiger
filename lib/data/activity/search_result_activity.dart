import 'package:flutter/material.dart';

import 'base_activity.dart';

@immutable
class SearchResultActivity extends BaseActivity {
  const SearchResultActivity({
    @required String activityId,
    @required String title,
    @required String shortDescription,
    @required String imageUrl,
  }) : super(
          id: activityId,
          title: title,
          shortDescription: shortDescription,
          image: imageUrl,
        );

  factory SearchResultActivity.fromJson(Map<String, dynamic> json) =>
      SearchResultActivity(
        activityId: json['activityId'] as String,
        title: json['title'] as String,
        shortDescription: json['shortDescription'] as String,
        imageUrl: json['imageUrl'] as String,
      );

  @override
  List<Object> get props => [id];
}
