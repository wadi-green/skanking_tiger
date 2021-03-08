import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_config.dart';
import '../core/colors.dart';
import '../core/images.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import '../screens/dashboard_screen.dart';
import '../screens/invitation_form_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/log_in_screen.dart';
import '../screens/messenger_list_screen.dart';
import '../screens/most_active_planters_screen.dart';
import '../screens/most_liked_activities_screen.dart';
import '../screens/my_activities_screen.dart';
import '../screens/personal_plant_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/sign_up_screen.dart';
import '../utils/strings.dart';
import '../utils/wadi_green_icons.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDrawerHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, layout) => Container(
                width: layout.maxWidth,
                height: layout.maxHeight,
                color: MainColors.primary,
                child: SingleChildScrollView(child: buildDrawerItems()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerHeader() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: LayoutBuilder(
            builder: (context, layout) => SvgPicture.asset(
              BrandImages.logoSvg,
              width: layout.maxWidth * 0.7,
            ),
          ),
        ),
      );

  Widget buildDrawerItems() => Selector<AuthModel, bool>(
        selector: (context, model) => model.isLoggedIn,
        builder: (context, isLoggedIn, child) {
          return Column(
            children: [
              const SizedBox(height: 16),
              if (isLoggedIn) ...loggedInDrawerItems else ...guestDrawerItems,
              const SizedBox(height: 16),
            ],
          );
        },
      );

  List<Widget> get loggedInDrawerItems => [
        buildDrawerItem(
            Strings.dashboard, WadiGreenIcons.dashboard, DashboardScreen.route),
        buildDrawerItem(Strings.home, WadiGreenIcons.home, LandingScreen.route),
        buildDrawerItem(Strings.activities, WadiGreenIcons.activities,
            MostLikedActivitiesScreen.route),
        buildDrawerItem(
            Strings.friends, WadiGreenIcons.users, MessengerListScreen.route),
        buildDrawerItem(Strings.personalPlant, WadiGreenIcons.plants,
            PersonalPlantScreen.route),
        buildDrawerItem(Strings.myActivities, WadiGreenIcons.userActivities,
            MyActivitiesScreen.route),
        buildDrawerItem(Strings.inviteFriends, WadiGreenIcons.userDoc,
            InvitationFormScreen.route),
        reportBugDrawerItem(),
        const SettingsDrawerTile(),
      ];

  List<Widget> get guestDrawerItems => [
        buildDrawerItem(Strings.home, WadiGreenIcons.home, LandingScreen.route),
        buildDrawerItem(Strings.activities, WadiGreenIcons.activities,
            MostLikedActivitiesScreen.route),
        buildDrawerItem(Strings.planters, WadiGreenIcons.users,
            MostActivePlantersScreen.route),
        buildDrawerItem(Strings.signUp, WadiGreenIcons.add, SignUpScreen.route),
        buildDrawerItem(Strings.login, Icons.login, LogInScreen.route),
        reportBugDrawerItem(),
      ];

  /// We're using the current route name to see if the drawer item should
  /// be active. That's why it's important to use [Navigator.pushNamed]
  /// instead of [Navigator.push] when pushing the routes
  Widget buildDrawerItem(String title, IconData icon, String destination) {
    return Builder(
      builder: (context) => DrawerTile(
        title: title,
        icon: icon,
        isActive: ModalRoute.of(context)?.settings?.name == destination,
        callback: () => Navigator.pushReplacementNamed(
          context,
          destination,
          arguments: const RouteArguments(isMain: true),
        ),
      ),
    );
  }

  Widget reportBugDrawerItem() => DrawerTile(
        title: Strings.reportABug,
        icon: WadiGreenIcons.warning,
        callback: () {
          launch('mailto:${AppConfig.supportEmail}?subject=Bug%20Report');
        },
      );
}

/// A special drawer tile that can expand and collapse instead of navigating to
/// a new screen
class SettingsDrawerTile extends StatelessWidget {
  const SettingsDrawerTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileHighlighted =
        ModalRoute.of(context)?.settings?.name == ProfileSettingsScreen.route;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: ExpansionTile(
          childrenPadding: const EdgeInsets.only(left: 12),
          title: const Text(
            Strings.settings,
            style: TextStyle(color: MainColors.white),
          ),
          initiallyExpanded: profileHighlighted,
          trailing: const Opacity(opacity: 0),
          leading: const Icon(WadiGreenIcons.settings, color: MainColors.white),
          children: [
            DrawerTile(
              title: Strings.profileSettings,
              icon: WadiGreenIcons.userCircle,
              isActive: profileHighlighted,
              callback: () => Navigator.pushReplacementNamed(
                context,
                ProfileSettingsScreen.route,
                arguments: const RouteArguments(isMain: true),
              ),
            ),
            DrawerTile(
              title: Strings.logout,
              icon: Icons.logout,
              callback: () {
                context.read<AuthModel>().logout();
                Navigator.pushReplacementNamed(
                  context,
                  LandingScreen.route,
                  arguments: const RouteArguments(isMain: true),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback callback;

  const DrawerTile({
    Key key,
    @required this.title,
    @required this.icon,
    this.callback,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.horizontal(left: Radius.circular(60));
    return ListTileTheme(
      iconColor: MainColors.white,
      textColor: MainColors.white,
      selectedTileColor: MainColors.accent,
      selectedColor: MainColors.white,
      style: ListTileStyle.drawer,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: ClipRRect(
          borderRadius: radius,
          // Material enables the ripple effect when tapping the list tile
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              selected: isActive,
              shape: const RoundedRectangleBorder(borderRadius: radius),
              leading: Icon(icon),
              title: Text(title),
              onTap: () {
                if (callback != null) {
                  Navigator.pop(context); // close the drawer
                  if (!isActive) {
                    callback();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
