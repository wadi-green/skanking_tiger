import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/text_styles.dart';
import '../../custom_painters/easiness_indicator_painter.dart';
import '../../data/activity/activity.dart';
import '../../data/activity/base_activity.dart';
import '../../data/route_arguments.dart';
import '../../screens/activity_details_screen.dart';
import '../../utils/strings.dart';
import '../common.dart';

class DetailedActivityTile extends StatelessWidget {
  final BaseActivity activity;

  const DetailedActivityTile({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const elementsSpacer = SizedBox(height: 4);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ActivityDetailsScreen.route,
          arguments: RouteArguments(
            data: {
              ActivityDetailsScreen.fetchActivityArg: () {
                if (activity is Activity) {
                  // Here we already have the full activity object, so we
                  // directly return it
                  return Future<Activity>.value(activity as Activity);
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 0.7, // portrait image
              child: CachedNetworkImage(
                imageUrl: activity.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => loadingImagePlaceholder,
              ),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: boxCardItemTitle(context)),
                elementsSpacer,
                Text(
                  activity.shortDescription,
                  style: shortDescriptionCaption(context),
                ),
                elementsSpacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.likes,
                      style: detailedTileLabel(context),
                    ),
                    Text(
                      '${activity.likes}',
                      style: detailedTileValue(context),
                    ),
                  ],
                ),
                elementsSpacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        Strings.ease,
                        style: detailedTileLabel(context),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: EasinessIndicatorPainter(
                            value: activity.ease.level,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
