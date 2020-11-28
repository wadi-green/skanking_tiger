import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The target group for which this activity is intended for
@immutable
class ActivityAudience extends Equatable {
  /// Which region of the world it applies to
  final String regionId;

  /// A collection of people who are working on it
  final String communityId;

  const ActivityAudience({
    @required this.regionId,
    @required this.communityId,
  });

  @override
  List<Object> get props => [regionId, communityId];

  factory ActivityAudience.fromJson(Map<String, dynamic> json) =>
      ActivityAudience(
        regionId: json['regionId'] as String,
        communityId: json['communityId'] as String,
      );
}
