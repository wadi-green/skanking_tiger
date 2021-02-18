import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/route_arguments.dart';
import '../screens/activity_details_screen.dart';
import '../screens/all_activities_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/invitation_form_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/log_in_screen.dart';
import '../screens/member_screen.dart';
import '../screens/messenger_list_screen.dart';
import '../screens/most_active_planters_screen.dart';
import '../screens/most_liked_activities_screen.dart';
import '../screens/my_activities_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/personal_plant_screen.dart';
import '../screens/plant_canvas_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/report_bug_screen.dart';
import '../screens/search_screen.dart';
import '../screens/sign_up_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final RouteArguments args = settings.arguments is RouteArguments
      ? settings.arguments as RouteArguments
      : const RouteArguments();

  final destination = _resolveDestination(settings.name, args);

  return args.isMain
      ? CupertinoPageRoute(builder: (_) => destination, settings: settings)
      : MaterialPageRoute(builder: (_) => destination, settings: settings);
}

Widget _resolveDestination(String routeName, RouteArguments args) {
  switch (routeName) {
    case ActivityDetailsScreen.route:
      return ActivityDetailsScreen(
        isMain: args.isMain,
        fetchActivityCallback: args.data[ActivityDetailsScreen.fetchActivityArg]
            as FetchActivityCallback,
      );
    case DashboardScreen.route:
      return DashboardScreen(isMain: args.isMain);
    case InvitationFormScreen.route:
      return InvitationFormScreen(isMain: args.isMain);
    case ReportBugScreen.route:
      return ReportBugScreen(isMain: args.isMain);
    case LandingScreen.route:
      return LandingScreen(isMain: args.isMain);
    case LogInScreen.route:
      return LogInScreen(isMain: args.isMain);
    case MemberScreen.route:
      return MemberScreen(
        isMain: args.isMain,
        fetchMemberCallback:
            args.data[MemberScreen.fetchMemberArg] as FetchMemberCallback,
      );
    case MyActivitiesScreen.route:
      return MyActivitiesScreen(isMain: args.isMain);
    case MessengerListScreen.route:
      return MessengerListScreen(isMain: args.isMain);
    case MostActivePlantersScreen.route:
      return MostActivePlantersScreen(isMain: args.isMain);
    case MostLikedActivitiesScreen.route:
      return MostLikedActivitiesScreen(isMain: args.isMain);
    case AllActivitiesScreen.route:
      return AllActivitiesScreen(
        isMain: args.isMain,
        query: args.data[SearchScreen.queryArg] as String,
      );
    case NotificationsScreen.route:
      return const NotificationsScreen();
    case PersonalPlantScreen.route:
      return PersonalPlantScreen(isMain: args.isMain);
    case PlantCanvasScreen.route:
      return PlantCanvasScreen(
        isMain: args.isMain,
        planterId: args.data[PlantCanvasScreen.planterIdArg] as String,
      );
    case ProfileSettingsScreen.route:
      return ProfileSettingsScreen(isMain: args.isMain);
    case SearchScreen.route:
      return SearchScreen(
        isMain: args.isMain,
        query: args.data[SearchScreen.queryArg] as String,
      );
    case SignUpScreen.route:
      return SignUpScreen(isMain: args.isMain);
    default:
      return LandingScreen(isMain: args.isMain);
  }
}

/// Can be used for the routes that have a drawer to give the impression that the
/// AppBar is fixed and only the content is changing
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  FadeRoute({this.page, this.duration = const Duration(milliseconds: 300)})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: duration,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: child),
        );
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
