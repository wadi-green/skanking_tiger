import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../utils/strings.dart';
import '../widgets/activities/detailed_activities_list.dart';
import '../widgets/wadi_scaffold.dart';

class AllActivitiesScreen extends StatelessWidget {
  static const route = '/all-activities';
  final bool isMain;
  final String query;
  const AllActivitiesScreen({Key key, this.isMain = false, this.query})
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
                title: Strings.allActivities,
                fetchActivitiesCallback: () {
                  return context.read<Api>().fetchActivities(sortedBy: 'likes', limit: 150, keyword: query);
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
