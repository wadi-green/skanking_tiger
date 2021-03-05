import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../data/activity/planter_activity.dart';
import '../../data/route_arguments.dart';
import '../../screens/activity_details_screen.dart';
import '../../utils/strings.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import '../custom_list_tile.dart';

class MyActivitiesList extends StatefulWidget {
  final String planterId;

  const MyActivitiesList({Key key, @required this.planterId})
      : assert(planterId != null),
        super(key: key);

  @override
  _MyActivitiesListState createState() => _MyActivitiesListState();
}

class _MyActivitiesListState extends State<MyActivitiesList> {
  Future<List<PlanterActivity>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<Api>().fetchPlanterActivities(widget.planterId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.myActivities,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      children: [
        AdvancedFutureBuilder<List<PlanterActivity>>(
          future: _future,
          builder: (activities) => Column(children: [
            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 12, top: 4),
                child: Text("You haven't started any activity yet!"),
              )
            else
              for (final activity in activities) ...[
                buildActivityTile(activity),
                const SizedBox(height: 12),
              ]
          ]),
          onRefresh: () {
            setState(() {
              _future =
                  context.read<Api>().fetchPlanterActivities(widget.planterId);
            });
          },
        ),
      ],
    );
  }

  Widget buildActivityTile(PlanterActivity activity) => CustomListTile(
        title: activity.title,
        subtitle: activity.shortDescription,
        imageUrl: activity.image,
        onTap: () {
          Navigator.of(context).pushNamed(
            ActivityDetailsScreen.route,
            arguments: RouteArguments(data: {
              ActivityDetailsScreen.fetchActivityArg: () {
                return context.read<Api>().fetchActivity(activity.id);
              }
            }),
          );
        },
      );
}
