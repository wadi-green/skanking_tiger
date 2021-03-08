import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../custom_painters/easiness_indicator_painter.dart';
import '../../data/activity/activity.dart';
import '../../models/activities_repository.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';
import 'activity_stats_widget.dart';

class ActivityStatsGrid extends StatefulWidget {
  final Activity activity;

  const ActivityStatsGrid({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  @override
  _ActivityStatsGridState createState() => _ActivityStatsGridState();
}

class _ActivityStatsGridState extends State<ActivityStatsGrid> {
  GlobalKey rightColKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Rebuild the widget after performing the first layout and getting the
      // right column height
      setState(() {});
    });
  }

  Widget leftColBuilder() {
    final keyContext = rightColKey.currentContext;
    // On the first render, the keyContext will be null since the right col wasn't
    // drawn yet. In that case we just return an empty container and wait for the
    // postFrameCallback to setState and re-render this widget
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      return SizedBox(
        height: box.size.height,
        child: CustomCard(
          title: Strings.ease,
          padding: innerEdgeInsets,
          children: [
            Text(widget.activity.ease.humanReadable),
            const SizedBox(height: 6),
            Expanded(
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: EasinessIndicatorPainter(
                    value: widget.activity.ease.level,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: leftColBuilder()),
        Expanded(
          child: Selector<ActivitiesRepository, Activity>(
            selector: (context, repo) =>
                repo.latestActivityVersion(widget.activity) as Activity,
            shouldRebuild: (prev, next) {
              return prev.likes != next.likes ||
                  prev.followers != next.followers;
            },
            builder: (context, activity, child) => Column(
              key: rightColKey,
              children: [
                ActivityStatsWidget(
                  title: Strings.likes,
                  stat: activity.likes,
                ),
                ActivityStatsWidget(
                  title: Strings.follows,
                  stat: activity.followers,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
