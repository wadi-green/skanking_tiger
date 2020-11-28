import 'package:flutter/material.dart';

import '../screens/activity_details_screen.dart';

@immutable
/// Used to pass any route arguments to the [Navigator.pushNamed] arguments
class RouteArguments {
  /// This argument is common to all screens and is used to determine whether
  /// the screen should have a drawer or not
  final bool isMain;

  /// Used to pass any type of data to the route resolver.
  /// In order to make everything consistent and easily maintainable, define
  /// the keys of the sent object as static constants inside the Screen widgets.
  /// Example: [ActivityDetailsScreen.fetchActivityArg]
  final Map<String, dynamic> data;

  const RouteArguments({this.isMain = false, this.data = const {}});
}
