import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../utils/strings.dart';
import '../widgets/activities/detailed_activities_list.dart';
import '../widgets/wadi_scaffold.dart';

class MostLikedActivitiesScreen extends StatelessWidget {
  static const route = '/most-liked-activities';
  final bool isMain;
  const MostLikedActivitiesScreen({Key key, this.isMain = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
          SliverToBoxAdapter(
            child: Padding(
              padding: hEdgeInsets,
              child: DetailedActivitiesList(
                title: Strings.mostLikedActivities,
                fetchActivitiesCallback: () {
                  return context.read<Api>().fetchActivities(sortedBy: 'likes');
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
        ],
      ),
    );
  }
}
