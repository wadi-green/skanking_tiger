import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../widgets/common.dart';
import '../widgets/landing/how_it_works.dart';
import '../widgets/landing/landing_call_to_action.dart';
import '../widgets/landing/most_liked_activities_grid.dart';
import '../widgets/landing/planters_overview_card.dart';
import '../widgets/search/search_box.dart';
import '../widgets/wadi_scaffold.dart';
import 'search_screen.dart';

class LandingScreen extends StatelessWidget {
  static const route = '/landing';
  final bool isMain;
  const LandingScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: Column(
            children: [
              SearchBox(
                onSubmit: (query) {
                  Navigator.of(context).pushNamed(
                    SearchScreen.route,
                    arguments: RouteArguments(
                      data: {SearchScreen.queryArg: query},
                    ),
                  );
                },
              ),
              cardsSpacer,
              const MostLikedActivitiesGrid(),
              cardsSpacer,
              const HowItWorks(),
              cardsSpacer,
              const PlantersOverviewCard(),
              Selector<AuthModel, bool>(
                selector: (_, model) => model.isLoggedIn,
                builder: (_, isLoggedIn, child) {
                  // This is displayed only for users that are not logged in
                  return isLoggedIn ? const SizedBox.shrink() : child;
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LandingCallToAction(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
