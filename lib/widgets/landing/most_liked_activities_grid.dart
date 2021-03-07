import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/constants.dart';
import '../../data/activity/activity.dart';
import '../../data/route_arguments.dart';
import '../../screens/activity_details_screen.dart';
import '../../screens/most_liked_activities_screen.dart';
import '../../utils/strings.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import '../grids/grid_box_item.dart';

class MostLikedActivitiesGrid extends StatefulWidget {
  const MostLikedActivitiesGrid({Key key}) : super(key: key);

  @override
  _MostLikedActivitiesGridState createState() =>
      _MostLikedActivitiesGridState();
}

class _MostLikedActivitiesGridState extends State<MostLikedActivitiesGrid> {
  Future<List<Activity>> _activities;

  @override
  void initState() {
    super.initState();
    _activities =
        context.read<Api>().fetchActivities(sortedBy: 'likes', limit: 2);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.mostLikedActivities,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      children: [
        LayoutBuilder(
          builder: (context, layout) => ConstrainedBox(
            constraints: BoxConstraints(minHeight: layout.maxWidth / 2),
            child: AdvancedFutureBuilder<List<Activity>>(
              future: _activities,
              onRefresh: () => setState(() {
                _activities = context
                    .read<Api>()
                    .fetchActivities(sortedBy: 'likes', limit: 2);
              }),
              builder: buildResults,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
              MostLikedActivitiesScreen.route,
            ),
            child: const Text(Strings.viewAll),
          ),
        ),
      ],
    );
  }

  Widget buildResults(List<Activity> activities) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: activities.length,
        gridDelegate: defaultGridDelegate,
        itemBuilder: (context, i) {
          final activity = activities[i];
          return GridBoxItem(
            title: activity.title,
            imgUrl: activity.image,
            onPressed: () {
              Navigator.pushNamed(
                context,
                ActivityDetailsScreen.route,
                arguments: RouteArguments(
                  data: {ActivityDetailsScreen.activityIdArg: activity.id},
                ),
              );
            },
          );
        },
      );
}
