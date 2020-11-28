import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// What role is the planter assigned in the system
@immutable
class Role extends Equatable {
  static const planter = 'PLANTER';
  static const moderator = 'MODERATOR';
  static const admin = 'ADMIN';

  final String value;

  const Role(this.value);

  String get humanReadable =>
      '${value.characters.first.toUpperCase()}${value.substring(1).toLowerCase()}';

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}
