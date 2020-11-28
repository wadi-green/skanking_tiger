import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../data/activity/activity.dart';
import '../../data/activity/base_activity.dart';
import '../../data/route_arguments.dart';
import '../../screens/activity_details_screen.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';
import '../custom_list_tile.dart';

class CompactActivitiesList extends StatelessWidget {
  final List<BaseActivity> activities;
  final String title;
  final VoidCallback callback;

  const CompactActivitiesList({
    Key key,
    @required this.title,
    @required this.activities,
    this.callback,
  })  : assert(activities != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      children: [
        for (final activity in activities) ...[
          buildActivityTile(context, activity),
          const SizedBox(height: 8),
        ],
        if (callback != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: callback,
              child: const Text(Strings.viewAll),
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }

  Widget buildActivityTile(BuildContext context, BaseActivity activity) {
    return CustomListTile(
      title: activity.title,
      subtitle: activity.shortDescription,
      imageUrl: activity.image,
      onTap: () {
        Navigator.of(context).pushNamed(
          ActivityDetailsScreen.route,
          arguments: RouteArguments(
            data: {
              ActivityDetailsScreen.fetchActivityArg: () {
                if (activity is Activity) {
                  // Here we already have the full activity object, so we
                  // directly return it
                  return Future<Activity>.value(activity);
                } else {
                  // Here we have one of the other representations of an
                  // activity so we need to fetch the full one
                  return context.read<Api>().fetchActivity(activity.id);
                }
              },
            },
          ),
        );
      },
    );
  }
}
