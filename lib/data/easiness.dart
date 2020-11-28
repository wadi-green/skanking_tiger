import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// How easy is the activity
@immutable
class Easiness extends Equatable {
  static const veryEasy = 'VERY_EASY';
  static const easy = 'EASY';
  static const medium = 'MEDIUM';
  static const hard = 'HARD';
  static const veryHard = 'VERY_HARD';

  final String value;

  const Easiness(this.value);

  String get humanReadable {
    switch (value) {
      case veryEasy:
        return 'Very easy';
      case easy:
        return 'Relatively easy';
      case medium:
        return 'Medium';
      case hard:
        return 'Relatively hard';
      case veryHard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  int get level {
    switch (value) {
      case veryEasy:
        return 1;
      case easy:
        return 2;
      case medium:
        return 3;
      case hard:
        return 4;
      case veryHard:
        return 5;
      default:
        return 0;
    }
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}
