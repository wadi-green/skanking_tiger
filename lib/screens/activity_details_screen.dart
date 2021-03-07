import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../data/activity/activity.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../widgets/activities/activity_header.dart';
import '../widgets/activities/activity_stats_grid.dart';
import '../widgets/activities/activity_steps_widget.dart';
import '../widgets/activities/external_links_widget.dart';
import '../widgets/activity_categories.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/common.dart';
import '../widgets/custom_card.dart';
import '../widgets/wadi_scaffold.dart';
import 'search_screen.dart';

class ActivityDetailsScreen extends StatefulWidget {
  static const route = '/activity-details';
  static const activityIdArg = 'activityId';

  final bool isMain;
  final String activityId;

  const ActivityDetailsScreen({
    Key key,
    @required this.activityId,
    this.isMain = false,
  })  : assert(activityId != null),
        super(key: key);

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  Future<Activity> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<Api>().fetchActivity(widget.activityId);
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: Center(
        child: AdvancedFutureBuilder<Activity>(
          future: _future,
          builder: buildBody,
          onRefresh: () {
            setState(() {
              _future = context.read<Api>().fetchActivity(widget.activityId);
            });
          },
        ),
      ),
    );
  }

  Widget buildBody(Activity activity) {
    return SingleChildScrollView(
      child: Padding(
        padding: wrapEdgeInsets,
        child: Column(
          children: [
            ActivityHeader(activity: activity),
            cardsSpacer,
            buildDescription(activity),
            cardsSpacer,
            Selector<AuthModel, bool>(
              selector: (_, model) {
                // Rebuilds the steps after accepting the activity
                return model.user?.activities?.contains(activity.id) ?? false;
              },
              shouldRebuild: (prev, next) => prev != next,
              builder: (_, recheckStatus, child) => ActivityStepsWidget(
                key: ValueKey('${activity.id}_$recheckStatus'),
                activity: activity,
              ),
            ),
            cardsSpacer,
            ActivityStatsGrid(activity: activity),
            cardsSpacer,
            if (activity.benefits.isNotEmpty) ...[
              buildBenefits(activity),
              cardsSpacer,
            ],
            if (activity.externalLinks.isNotEmpty) ...[
              ExternalLinksWidget(activity: activity),
              cardsSpacer,
            ],
            ActivityCategories(
              title: Strings.activityCategories,
              categories: activity.categories,
              onPressed: (category) {
                Navigator.of(context).pushNamed(
                  SearchScreen.route,
                  arguments: RouteArguments(
                    data: {SearchScreen.queryArg: category},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescription(Activity activity) => CustomCard(
        title: Strings.fullDescription,
        padding: innerEdgeInsets,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(activity.longDescription),
          )
        ],
      );

  Widget buildBenefits(Activity activity) {
    final textTheme = Theme.of(context).textTheme.bodyText2;
    return CustomCard(
      title: Strings.benefits,
      padding: innerEdgeInsets,
      children: [
        for (final benefit in activity.benefits)
          ListTile(
            contentPadding: const EdgeInsets.only(left: 12),
            leading: Icon(benefit.iconData, size: 32),
            title: Text(benefit.description, style: textTheme),
          ),
      ],
    );
  }
}
