import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../utils/strings.dart';
import '../widgets/planters/detailed_planters_list.dart';
import '../widgets/wadi_scaffold.dart';

class MostActivePlantersScreen extends StatelessWidget {
  static const route = '/most-active-planters';
  final bool isMain;
  const MostActivePlantersScreen({Key key, this.isMain = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
          SliverToBoxAdapter(
            child: Padding(
              padding: hEdgeInsets,
              child: DetailedPlantersList(
                title: Strings.mostActivePlanters,
                fetchPlantersCallback: () {
                  return context
                      .read<Api>()
                      .fetchPlanters(sortedBy: 'activity', limit: 4);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
        ],
      ),
    );
  }
}
