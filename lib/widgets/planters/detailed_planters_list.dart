import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/planter.dart';
import '../../data/route_arguments.dart';
import '../../screens/member_screen.dart';
import '../advanced_future_builder.dart';
import '../custom_card.dart';
import 'detailed_planter_tile.dart';

class DetailedPlantersList extends StatefulWidget {
  final String title;

  /// The function to be called when getting the planters. This allows for
  /// a lot of flexibility with specifying parameters and makes this widget
  /// reusable for all places where showing a list of planters is needed
  final Future<List<Planter>> Function() fetchPlantersCallback;

  const DetailedPlantersList({
    Key key,
    @required this.title,
    @required this.fetchPlantersCallback,
  })  : assert(fetchPlantersCallback != null),
        assert(title != null),
        super(key: key);

  @override
  _DetailedPlantersListState createState() => _DetailedPlantersListState();
}

class _DetailedPlantersListState extends State<DetailedPlantersList> {
  Future<List<Planter>> _planters;

  @override
  void initState() {
    super.initState();
    _planters = widget.fetchPlantersCallback();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.title,
      padding: innerEdgeInsets,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: AdvancedFutureBuilder<List<Planter>>(
            future: _planters,
            builder: buildPlantersList,
            onRefresh: () => setState(() {
              _planters = widget.fetchPlantersCallback();
            }),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget buildPlantersList(List<Planter> planters) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: planters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => DetailedPlanterTile(
        planter: planters[i],
        onTap: () {
          final planter = planters[i];
          Navigator.of(context).pushNamed(
            MemberScreen.route,
            arguments: RouteArguments(
              data: {
                MemberScreen.fetchMemberArg: () =>
                    Future<Planter>.value(planter),
              },
            ),
          );
        },
      ),
    );
  }
}
