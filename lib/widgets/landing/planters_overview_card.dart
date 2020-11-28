import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/constants.dart';
import '../../data/planter.dart';
import '../../data/route_arguments.dart';
import '../../screens/member_screen.dart';
import '../../screens/most_active_planters_screen.dart';
import '../../utils/strings.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import '../grids/grid_box_item.dart';

class PlantersOverviewCard extends StatefulWidget {
  const PlantersOverviewCard({Key key}) : super(key: key);

  @override
  _PlantersOverviewCardState createState() => _PlantersOverviewCardState();
}

class _PlantersOverviewCardState extends State<PlantersOverviewCard> {
  Future<List<Planter>> _planters;

  @override
  void initState() {
    super.initState();
    _planters =
        context.read<Api>().fetchPlanters(sortedBy: 'activity', limit: 2);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.mostActivePlanters,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      children: [
        LayoutBuilder(
          builder: (context, layout) => ConstrainedBox(
            constraints: BoxConstraints(minHeight: layout.maxWidth / 2),
            child: AdvancedFutureBuilder<List<Planter>>(
              future: _planters,
              onRefresh: () => setState(() {
                _planters = context
                    .read<Api>()
                    .fetchPlanters(sortedBy: 'activity', limit: 2);
              }),
              builder: buildResults,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
              MostActivePlantersScreen.route,
            ),
            child: const Text(Strings.viewAll),
          ),
        ),
      ],
    );
  }

  Widget buildResults(List<Planter> planters) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: planters.length,
        gridDelegate: defaultGridDelegate,
        itemBuilder: (context, i) {
          final planter = planters[i];
          return GridBoxItem(
            title: planter.fullName,
            imgUrl: planter.picture,
            onPressed: () {
              Navigator.pushNamed(
                context,
                MemberScreen.route,
                arguments: RouteArguments(data: {
                  MemberScreen.fetchMemberArg: () =>
                      Future<Planter>.value(planter),
                }),
              );
            },
          );
        },
      );
}
