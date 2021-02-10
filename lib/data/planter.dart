import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'activity_category.dart';
import 'role.dart';

/// The planter entity. The actual logged-in user who interacts with the system
@immutable
class Planter extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String country;
  final String aboutMe;
  // what role is the planter assigned in the system
  final Role role;
  final int karma;
  // Since when is this planter helping out on the platform in days
  final int maturity;
  // identifier of the canvas of this planter
  final String plantCanvasId;
  // When was the last time this planter was active on the system
  final String lastLoggedIn;
  // A direct link to the profile page of this planter
  final String profileUrl;
  final String picture;
  final int totalPlants;
  final List<ActivityCategory> mostActiveCategories;
  final List<String> activities;

  const Planter({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.profileUrl,
    @required this.email,
    @required this.city,
    @required this.country,
    @required this.aboutMe,
    @required this.role,
    @required this.karma,
    @required this.maturity,
    @required this.plantCanvasId,
    @required this.lastLoggedIn,
    @required this.picture,
    @required this.totalPlants,
    @required this.mostActiveCategories,
    @required this.activities,
  });

  @override
  List<Object> get props => [id];

  String get fullName => '$firstName $lastName';

  factory Planter.fromJson(Map<String, dynamic> json) => Planter(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        profileUrl: json['profileUrl'] as String,
        email: json['email'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        aboutMe: json['aboutMe'] as String,
        role: Role(json['role'] as String),
        karma: json['karma'] as int,
        maturity: json['maturity'] as int,
        plantCanvasId: json['plantCanvasId'] as String,
        lastLoggedIn: json['lastLoggedIn'] as String,
        picture: json['picture'] as String,
        totalPlants: json['totalPlants'] as int,
        mostActiveCategories: (json['categories'] as List ?? [])
            .map((e) => ActivityCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
        activities: (json['activities'] as List ?? []).map<String>((m) => m as String).toList()
      );

  Planter copyWith({
    String id,
    String firstName,
    String lastName,
    String email,
    String city,
    String country,
    String aboutMe,
    Role role,
    int karma,
    int maturity,
    String plantCanvasId,
    String lastLoggedIn,
    String profileUrl,
    String picture,
    int totalPlants,
    List<ActivityCategory> mostActiveCategories,
    List<String> activities,
  }) =>
      Planter(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileUrl: profileUrl ?? this.profileUrl,
        email: email ?? this.email,
        city: city ?? this.city,
        country: country ?? this.country,
        aboutMe: aboutMe ?? this.aboutMe,
        role: role ?? this.role,
        karma: karma ?? this.karma,
        maturity: maturity ?? this.maturity,
        plantCanvasId: plantCanvasId ?? this.plantCanvasId,
        lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
        picture: picture ?? this.picture,
        totalPlants: totalPlants ?? this.totalPlants,
        mostActiveCategories: mostActiveCategories ?? this.mostActiveCategories,
        activities: activities ?? this.activities,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'profileUrl': profileUrl,
        'email': email,
        'city': city,
        'country': country,
        'aboutMe': aboutMe,
        'role': role.value,
        'karma': karma,
        'maturity': maturity,
        'plantCanvasId': plantCanvasId,
        'lastLoggedIn': lastLoggedIn,
        'picture': picture,
        'totalPlants': totalPlants,
        'categories': mostActiveCategories.map((c) => c.toJson()).toList(),
      };
}
