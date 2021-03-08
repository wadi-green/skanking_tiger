import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../easiness.dart';

/// Base class holding the common fields between [Activity] and [PlanterActivity]
/// in order to allow using the common widgets for both types
@immutable
class BaseActivity extends Equatable {
  final String id;
  final String title;
  final String image;
  final String shortDescription;
  final int likes;
  final Easiness ease;

  const BaseActivity({
    @required this.id,
    @required this.title,
    @required this.image,
    @required this.shortDescription,
    this.likes,
    this.ease,
  });

  String get likesCompact => NumberFormat.compact().format(likes);

  @override
  List<Object> get props => [id, likes];
}
