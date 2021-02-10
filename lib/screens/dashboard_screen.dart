import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/data/login_response.dart';

import '../core/constants.dart';
import '../core/text_styles.dart';
import '../data/planter.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../utils/wadi_green_icons.dart';
import '../widgets/activities/activity_stats_widget.dart';
import '../widgets/activity_categories.dart';
import '../widgets/common.dart';
import '../widgets/custom_card.dart';
import '../widgets/dashboard/friends_activities_list.dart';
import '../widgets/dashboard/my_activities_list.dart';
import '../widgets/dashboard/planter_calendar.dart';
import '../widgets/wadi_scaffold.dart';
import 'search_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const route = '/dashboard';
  final bool isMain;
  const DashboardScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: Selector<AuthModel, Planter>(
        selector: (context, model) => model.user,
        builder: (context, user, child) {
          if (user == null) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                Strings.unauthorizedAccess,
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: wrapEdgeInsets,
              child: Column(
                children: [
                  buildHeader(context, user),
                  cardsSpacer,
                  FriendsActivitiesList(planterId: user.id),
                  cardsSpacer,
                  buildStats(context, user),
                  cardsSpacer,
                  MyActivitiesList(planterId: user.id),
                  cardsSpacer,
                  PlanterCalendar(planter: user, title: Strings.myCalendar),
                  cardsSpacer,
                  ActivityCategories(
                    title: Strings.activityCategories,
                    categories: user.mostActiveCategories,
                    onPressed: (category) {
                      Navigator.of(context).pushNamed(
                        SearchScreen.route,
                        arguments: RouteArguments(
                          data: {SearchScreen.queryArg: category},
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeader(BuildContext context, Planter user) {
    return CustomCard(
      padding: innerEdgeInsets,
      children: [
        SizedBox(
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CachedNetworkImage(
                  imageUrl: user.picture,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 130,
                  placeholder: (_, __) => loadingImagePlaceholder,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: itemTitle(context)),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      child: Text(
                        user.aboutMe,
                        style: shortDescriptionCaption(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Spacer(),
                    Text(
                      '${Strings.role}: ${user.role.humanReadable}',
                      style: roleStyle(context),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget buildStats(BuildContext context, Planter user) {
    return Row(
      children: [
        Expanded(
          child: ActivityStatsWidget(
            title: Strings.karma,
            stat: user.karma,
          ),
        ),
        Expanded(
          child: ActivityStatsWidget(
            title: Strings.plants,
            stat: user.totalPlants,
            icon: Row(
              children: const [
                FaIcon(WadiGreenIcons.plant),
                SizedBox(width: 2),
                FaIcon(WadiGreenIcons.plant),
                SizedBox(width: 2),
                FaIcon(WadiGreenIcons.plant),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
