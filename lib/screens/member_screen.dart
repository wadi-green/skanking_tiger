import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../data/planter.dart';
import '../utils/strings.dart';
import '../widgets/activities/detailed_activities_list.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/custom_card.dart';
import '../widgets/planters/detailed_planter_tile.dart';
import '../widgets/planters/planter_actions.dart';
import '../widgets/wadi_scaffold.dart';

typedef FetchMemberCallback = Future<Planter> Function();

class MemberScreen extends StatefulWidget {
  static const route = '/member-details';
  static const fetchMemberArg = 'fetchMember';

  final bool isMain;
  final FetchMemberCallback fetchMemberCallback;

  const MemberScreen({
    Key key,
    @required this.fetchMemberCallback,
    this.isMain = false,
  })  : assert(fetchMemberCallback != null),
        super(key: key);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  Future<Planter> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fetchMemberCallback();
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: AdvancedFutureBuilder<Planter>(
        future: _future,
        builder: (member) => _MemberDetails(member: member),
        onRefresh: () {
          setState(() {
            _future = widget.fetchMemberCallback();
          });
        },
      ),
    );
  }
}

class _MemberDetails extends StatelessWidget {
  final Planter member;

  const _MemberDetails({Key key, @required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: wrapEdgeInsets,
        child: Column(
          children: [
            CustomCard(
              padding: innerEdgeInsets,
              children: [DetailedPlanterTile(planter: member)],
            ),
            PlanterActions(member: member),
            DetailedActivitiesList(
              title: Strings.activities,
              fetchActivitiesCallback: () {
                return context.read<Api>().fetchPlanterActivities(member.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
