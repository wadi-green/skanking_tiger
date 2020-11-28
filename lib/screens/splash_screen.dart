import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../core/images.dart';
import '../data/route_arguments.dart';
import '../models/auth_model.dart';
import 'dashboard_screen.dart';
import 'landing_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      // In debug, native splash remains for around 2 seconds, but in prod it's
      // less than a second. That's why native splash is not used: it won't even
      // be visible to the user.
      const Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(
        context,
        context.read<AuthModel>().isLoggedIn
            ? DashboardScreen.route
            : LandingScreen.route,
        arguments: const RouteArguments(isMain: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MainColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 52),
        child: Center(
          child: SvgPicture.asset(
            BrandImages.logoSvg,
            width: double.maxFinite,
          ),
        ),
      ),
    );
  }
}
