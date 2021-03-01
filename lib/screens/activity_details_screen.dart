import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/data/planter.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../core/images.dart';
import '../core/text_styles.dart';
import '../data/activity/activity.dart';
import '../data/checkin_activity_type.dart';
import '../data/planter_checkin.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../utils/wadi_green_icons.dart';
import '../widgets/activities/activity_stats_grid.dart';
import '../widgets/activities/activity_steps_widget.dart';
import '../widgets/activities/external_links_widget.dart';
import '../widgets/activity_categories.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/common.dart';
import '../widgets/custom_card.dart';
import '../widgets/wadi_scaffold.dart';
import 'log_in_screen.dart';
import 'search_screen.dart';

typedef FetchActivityCallback = Future<Activity> Function();

class ActivityDetailsScreen extends StatefulWidget {
  static const route = '/activity-details';
  static const fetchActivityArg = 'fetchActivity';

  final bool isMain;
  final FetchActivityCallback fetchActivityCallback;

  const ActivityDetailsScreen({
    Key key,
    @required this.fetchActivityCallback,
    this.isMain = false,
  })  : assert(fetchActivityCallback != null),
        super(key: key);

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  Future<Activity> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fetchActivityCallback();
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: AdvancedFutureBuilder<Activity>(
        future: _future,
        builder: (activity) => _ActivityDetails(activity: activity),
        onRefresh: () {
          setState(() {
            _future = widget.fetchActivityCallback();
          });
        },
      ),
    );
  }
}

class _ActivityDetails extends StatelessWidget {
  final Activity activity;

  const _ActivityDetails({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: wrapEdgeInsets,
        child: Column(
          children: [
            buildHeader(context),
            cardsSpacer,
            buildDescription(context),
            cardsSpacer,
            ActivityStepsWidget(activity: activity),
            cardsSpacer,
            ActivityStatsGrid(activity: activity),
            cardsSpacer,
            buildBenefits(context),
            cardsSpacer,
            ExternalLinksWidget(activity: activity),
            cardsSpacer,
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

  Widget buildHeader(BuildContext context) => CustomCard(
        padding: innerEdgeInsets,
        children: [
          AspectRatio(
            aspectRatio: 2, // To make it a landscape image
            child: CachedNetworkImage(
              imageUrl: activity.image,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => loadingImagePlaceholder,
            ),
          ),
          const SizedBox(height: 12),
          Text(activity.title, style: itemTitle(context)),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: EdgeInsets.zero,
            children: [
              IconButton(
                tooltip: 'Add to my activities',
                icon: const FaIcon(
                  WadiGreenIcons.addActivity,
                  color: MainColors.darkGrey,
                ),
                onPressed: () async {
                  if (context.read<AuthModel>().isLoggedIn) {
                    await context.read<Api>().logPlanterCheckIn(
                          context.read<AuthModel>().user.id,
                          PlanterCheckIn(
                            activityId: activity.id,
                            activityTitle: activity.title,
                            activityStep: -1,
                            checkinType: const CheckInActivityType(
                                CheckInActivityType.newActivityStarted),
                            comment: '${activity.id} started',
                            timestamp: DateTime.now().toIso8601String(),
                          ),
                          context.read<AuthModel>().tokenData.accessToken,
                        );
                    // update planter in context
                    final updatedPlanter = await context
                        .read<Api>()
                        .fetchPlanter(context.read<AuthModel>().user.id);
                    context.read<AuthModel>().updateUser(updatedPlanter);
                  } else {
                    Navigator.pushNamed(context, LogInScreen.route);
                  }
                },
              ),
              IconButton(
                tooltip: 'Share',
                icon: const FaIcon(
                  WadiGreenIcons.share,
                  color: MainColors.darkGrey,
                ),
                onPressed: () {
                  if (context.read<AuthModel>().isLoggedIn) {
                    // TODO
                  } else {
                    Navigator.pushNamed(context, LogInScreen.route);
                  }
                },
              ),
              IconButton(
                tooltip: 'Like',
                icon: Center(
                  child: SvgPicture.asset(
                    SvgImages.likeBold,
                    width: 25,
                    color: MainColors.darkGrey,
                  ),
                ),
                alignment: Alignment.topCenter,
                onPressed: () async {
                  if (context.read<AuthModel>().isLoggedIn) {
                    await context.read<Api>().likeActivity(
                          context.read<AuthModel>().user.id,
                          activity.id,
                          context.read<AuthModel>().tokenData.accessToken,
                        );
                  } else {
                    Navigator.pushNamed(context, LogInScreen.route);
                  }
                },
              ),
            ],
          ),
        ],
      );

  Widget buildDescription(BuildContext context) => CustomCard(
        title: Strings.fullDescription,
        padding: innerEdgeInsets,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(activity.longDescription),
          )
        ],
      );

  Widget buildBenefits(BuildContext context) {
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
