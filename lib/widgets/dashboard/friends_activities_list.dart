import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../data/planter_friend.dart';
import '../../data/route_arguments.dart';
import '../../screens/member_screen.dart';
import '../../utils/strings.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import '../custom_list_tile.dart';

class FriendsActivitiesList extends StatefulWidget {
  final String planterId;

  const FriendsActivitiesList({Key key, @required this.planterId})
      : assert(planterId != null),
        super(key: key);

  @override
  _FriendsActivitiesListState createState() => _FriendsActivitiesListState();
}

class _FriendsActivitiesListState extends State<FriendsActivitiesList> {
  Future<List<PlanterFriend>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<Api>().fetchPlanterFriends(widget.planterId, 4);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.friendsActivities,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      children: [
        AdvancedFutureBuilder<List<PlanterFriend>>(
          future: _future,
          builder: (friends) => Column(children: [
            if (friends.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 12, top: 4),
                child: Text("Your friends didn't start any activity yet!"),
              )
            else
              for (final friend in friends) ...[
                buildFriendTile(friend),
                const SizedBox(height: 12),
              ]
          ]),
          onRefresh: () {
            setState(() {
              _future =
                  context.read<Api>().fetchPlanterFriends(widget.planterId, 4);
            });
          },
        ),
      ],
    );
  }

  Widget buildFriendTile(PlanterFriend friend) => CustomListTile(
        title: friend.name,
        subtitle: friend.recentActivity,
        imageUrl: friend.picture,
        onTap: () {
          Navigator.of(context).pushNamed(
            MemberScreen.route,
            arguments: RouteArguments(data: {
              MemberScreen.fetchMemberArg: () {
                return context.read<Api>().fetchPlanter(friend.id);
              }
            }),
          );
        },
      );
}
