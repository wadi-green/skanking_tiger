import 'package:flutter/material.dart';

import '../data/activity/activity.dart';
import '../data/activity/base_activity.dart';

/// This repository is used to fetch the latest activity data for the ones that
/// the user interacts with. Activities are present in multiple places in the
/// app, so keeping everything in sync might be tricky. So as an alternative,
/// we're keeping a single source of truth with the latest data and it's used
/// to display the proper data where needed and applicable (for example: likes
/// and follows)
class ActivitiesRepository extends ChangeNotifier {
  final Map<String, Activity> _activities = {};

  void updateActivity(Activity activity) {
    _activities[activity.id] = activity;
    notifyListeners();
  }

  BaseActivity latestActivityVersion(BaseActivity activity) {
    if (_activities.containsKey(activity.id)) {
      return _activities[activity.id];
    } else {
      // No version yet, just return the one being sent by the user
      return activity;
    }
  }
}
