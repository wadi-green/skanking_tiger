import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../core/hive_boxes.dart';
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
            if (activity.benefits.isNotEmpty) ...[
              buildBenefits(context),
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

  Widget buildHeader(BuildContext context) => CustomCard(
        padding: innerEdgeInsets,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            child: AspectRatio(
              aspectRatio: 2, // To make it a landscape image
              child: CachedNetworkImage(
                imageUrl: activity.image,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => loadingImagePlaceholder,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(activity.title, style: itemTitle(context)),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: EdgeInsets.zero,
            children: [
              Consumer<AuthModel>(
                builder: (context, model, child) {
                  final isAdded = model.user.activities.contains(activity.id);
                  final btn = IconButton(
                    tooltip: 'Add to my activities',
                    color: Colors.white,
                    icon: FaIcon(
                      WadiGreenIcons.addActivity,
                      color:
                          isAdded ? MainColors.lightGreen : MainColors.darkGrey,
                    ),
                    onPressed: () {
                      final authModel = context.read<AuthModel>();
                      if (!authModel.isLoggedIn) {
                        Navigator.pushNamed(context, LogInScreen.route);
                      } else if (!authModel.user.activities
                          .contains(activity.id)) {
                        addToMyActivities(context);
                      }
                    },
                  );
                  return isAdded ? btn : _StartActivityNudge(button: btn);
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
                  child: ValueListenableBuilder<Box>(
                    valueListenable:
                        Hive.box(ActivityLikesBox.key).listenable(),
                    builder: (context, box, child) {
                      return SvgPicture.asset(
                        SvgImages.likeBold,
                        width: 25,
                        color: box.containsKey(activity.id)
                            ? MainColors.lightGreen
                            : MainColors.darkGrey,
                      );
                    },
                  ),
                ),
                alignment: Alignment.topCenter,
                onPressed: () {
                  if (context.read<AuthModel>().isLoggedIn) {
                    addToLikes(context);
                  } else {
                    Navigator.pushNamed(context, LogInScreen.route);
                  }
                },
              ),
            ],
          ),
        ],
      );

  Future<void> addToLikes(BuildContext context) async {
    try {
      if (context.read<AuthModel>().isLoggedIn) {
        await context.read<Api>().likeActivity(
              context.read<AuthModel>().user.id,
              activity.id,
              context.read<AuthModel>().tokenData.accessToken,
            );
        ActivityLikesBox.triggerLike(activity.id);
      } else {
        Navigator.pushNamed(context, LogInScreen.route);
      }
    } catch (e, tr) {
      debugPrint(tr.toString());
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> addToMyActivities(BuildContext context) async {
    try {
      final authModel = context.read<AuthModel>();
      await context.read<Api>().logPlanterCheckIn(
            authModel.user.id,
            PlanterCheckIn(
              activityId: activity.id,
              activityTitle: activity.title,
              activityStep: -1,
              checkinType: const CheckInActivityType(
                  CheckInActivityType.newActivityStarted),
              comment: '${activity.id} started',
              timestamp: DateTime.now().toIso8601String(),
            ),
            authModel.tokenData.accessToken,
          );
      // update planter in context
      final updatedPlanter =
          await context.read<Api>().fetchPlanter(authModel.user.id);
      authModel.updateUser(updatedPlanter);
    } catch (e, tr) {
      debugPrint(tr.toString());
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

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

class _StartActivityNudge extends StatefulWidget {
  final Widget button;
  const _StartActivityNudge({Key key, @required this.button}) : super(key: key);

  @override
  _StartActivityNudgeState createState() => _StartActivityNudgeState();
}

class _StartActivityNudgeState extends State<_StartActivityNudge>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        'Start activity',
        style: Theme.of(context).textTheme.caption,
      ),
      const Icon(
        Icons.arrow_right_alt,
        color: MainColors.darkGrey,
        size: 18,
      ),
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => SizedBox(width: _animation.value),
      ),
      widget.button,
    ]);
  }
}
