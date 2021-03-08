import 'package:flutter/material.dart';

import '../../core/text_styles.dart';
import '../../data/activity/base_activity.dart';
import '../../data/route_arguments.dart';
import '../../screens/activity_details_screen.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';
import '../custom_list_tile.dart';

class CompactActivitiesList extends StatelessWidget {
  final List<BaseActivity> activities;
  final String title;
  final String subtitle;
  final VoidCallback callback;

  const CompactActivitiesList({
    Key key,
    @required this.title,
    this.subtitle,
    @required this.activities,
    this.callback,
  })  : assert(activities != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      titleSpacing: 0,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      children: [
        if (activities.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(Strings.noResultsFound),
          )
        else ...[
          if (subtitle != null) Text(subtitle, style: searchSubtitle(context)),
          const SizedBox(height: 12),
          for (final activity in activities) ...[
            buildActivityTile(context, activity),
            const SizedBox(height: 16),
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
        ]
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
            data: {ActivityDetailsScreen.activityIdArg: activity.id},
          ),
        );
      },
    );
  }
}
