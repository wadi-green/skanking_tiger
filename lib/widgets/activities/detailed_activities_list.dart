import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/activity/base_activity.dart';
import '../../utils/strings.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import 'detailed_activity_tile.dart';

class DetailedActivitiesList extends StatefulWidget {
  final String title;

  /// The function to be called when getting the activities. This allows for
  /// a lot of flexibility with specifying parameters and makes this widget
  /// reusable for all places where showing a list of activities is needed
  final Future<List<BaseActivity>> Function() fetchActivitiesCallback;

  final VoidCallback onViewAll;

  const DetailedActivitiesList({
    Key key,
    @required this.title,
    @required this.fetchActivitiesCallback,
    this.onViewAll,
  })  : assert(fetchActivitiesCallback != null),
        assert(title != null),
        super(key: key);

  @override
  _DetailedActivitiesListState createState() => _DetailedActivitiesListState();
}

class _DetailedActivitiesListState extends State<DetailedActivitiesList> {
  Future<List<BaseActivity>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = widget.fetchActivitiesCallback();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.title,
      padding: innerEdgeInsets,
      children: [
        AdvancedFutureBuilder<List<BaseActivity>>(
          future: _activities,
          builder: buildActivitiesList,
          onRefresh: () => setState(() {
            _activities = widget.fetchActivitiesCallback();
          }),
        ),
        if (widget.onViewAll != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onViewAll,
              child: const Text(Strings.viewAll),
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }

  Widget buildActivitiesList(List<BaseActivity> activities) {
    if (activities.isEmpty) {
      return const Text('No activities yet!');
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => DetailedActivityTile(activity: activities[i]),
    );
  }
}
