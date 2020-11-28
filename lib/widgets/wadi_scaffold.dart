import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../core/images.dart';
import '../models/auth_model.dart';
import '../screens/notifications_screen.dart';
import 'custom_drawer.dart';

/// Since the screens on the app don't have titles in their [AppBar], there's
/// no need to rewrite the appbar and the drawer every time in the app.
/// This Scaffold takes care of doing that for us.
class WadiScaffold extends StatelessWidget {
  final Widget body;
  final bool hasDrawer;

  const WadiScaffold({Key key, @required this.body, this.hasDrawer = true})
      : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthModel, bool>(
      (model) => model.isLoggedIn,
    );
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(BrandImages.emblemSvg),
        centerTitle: false,
        titleSpacing: 4,
        actions: [
          if (isLoggedIn &&
              ModalRoute.of(context).settings.name != NotificationsScreen.route)
            IconButton(
              icon: SvgPicture.asset(
                SvgImages.bell,
                width: 20,
                color: MainColors.darkGrey,
              ),
              onPressed: () {
                Navigator.pushNamed(context, NotificationsScreen.route);
              },
            ),
        ],
      ),
      drawer: hasDrawer ? const CustomDrawer() : null,
      body: body,
    );
  }
}
