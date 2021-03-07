import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/hive_boxes.dart';
import '../../core/images.dart';
import '../../core/text_styles.dart';
import '../../data/activity/activity.dart';
import '../../data/checkin_activity_type.dart';
import '../../data/planter_checkin.dart';
import '../../models/activities_repository.dart';
import '../../models/auth_model.dart';
import '../../screens/log_in_screen.dart';
import '../../utils/wadi_green_icons.dart';
import '../common.dart';
import '../custom_card.dart';

class ActivityHeader extends StatelessWidget {
  final Activity activity;

  const ActivityHeader({Key key, @required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
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
                  valueListenable: Hive.box(ActivityLikesBox.key).listenable(),
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
  }

  Future<void> addToLikes(BuildContext context) async {
    try {
      final authModel = context.read<AuthModel>();
      await context.read<Api>().likeActivity(
            authModel.user.id,
            activity.id,
            authModel.tokenData.accessToken,
          );
      ActivityLikesBox.triggerLike(activity.id);
      context.read<Api>().fetchActivity(activity.id).then((value) {
        context.read<ActivitiesRepository>().updateActivity(value);
      });
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
      context.read<Api>().fetchActivity(activity.id).then((value) {
        context.read<ActivitiesRepository>().updateActivity(value);
      });
      // update planter in context
      context.read<Api>().fetchPlanter(authModel.user.id).then((value) {
        authModel.updateUser(value);
      });
    } catch (e, tr) {
      debugPrint(tr.toString());
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
