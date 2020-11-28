import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../data/chat.dart';
import '../data/planter.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../widgets/activities/detailed_activities_list.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/chat/messenger_chat_route.dart';
import '../widgets/custom_card.dart';
import '../widgets/planters/detailed_planter_tile.dart';
import '../widgets/wadi_scaffold.dart';
import 'plant_canvas_screen.dart';

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
            Consumer<AuthModel>(builder: (context, authModel, child) {
              if (!authModel.isLoggedIn) return const SizedBox(height: 12);

              return ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PlantCanvasScreen.route,
                        arguments: RouteArguments(data: {
                          PlantCanvasScreen.planterIdArg: member.id,
                        }),
                      );
                    },
                    child: const Text(Strings.viewPlants),
                  ),
                  if (authModel.user?.id != member.id)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MessengerChatRoute(Chat.fromPlanter(member)),
                        );
                      },
                      child: const Text(Strings.message),
                    ),
                ],
              );
            }),
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
