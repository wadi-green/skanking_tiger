import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'plant.dart';

/// The garden of plants owned by a planter
@immutable
class PlanterCanvas extends Equatable {
  final String id;
  final List<Plant> plants;

  const PlanterCanvas({
    @required this.id,
    @required this.plants,
  });

  @override
  List<Object> get props => [id];

  factory PlanterCanvas.fromJson(Map<String, dynamic> json) => PlanterCanvas(
        id: json['id'] as String,
        plants: (json['plants'] as List ?? [])
            .map((e) => Plant.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
