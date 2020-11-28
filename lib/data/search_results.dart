import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'activity/search_result_activity.dart';
import 'activity_category.dart';
import 'search_result_hashtags.dart';

@immutable
class SearchResults extends Equatable {
  final List<SearchResultActivity> results;
  final SearchResultHashtags hashtags;
  final List<ActivityCategory> categories;
  final List<SearchResultActivity> mostLikedActivities;

  const SearchResults({
    @required this.results,
    @required this.hashtags,
    @required this.categories,
    @required this.mostLikedActivities,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        results: (json['results'] as List ?? [])
            .map((e) => SearchResultActivity.fromJson(
                  e as Map<String, dynamic>,
                ))
            .toList(),
        hashtags: SearchResultHashtags.fromJson(
            json['hashtags'] as Map<String, dynamic>),
        categories: (json['categories'] as List ?? [])
            .map((e) => ActivityCategory.fromJson(
                  e as Map<String, dynamic>,
                ))
            .toList(),
        mostLikedActivities: (json['mostLikedActivities'] as List ?? [])
            .map((e) => SearchResultActivity.fromJson(
                  e as Map<String, dynamic>,
                ))
            .toList(),
      );

  @override
  List<Object> get props =>
      [results, hashtags, categories, mostLikedActivities];
}
