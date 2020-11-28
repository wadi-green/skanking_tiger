import 'package:flutter/material.dart';

import 'core/routes.dart';
import 'core/themes.dart';
import 'screens/splash_screen.dart';
import 'utils/strings.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      onGenerateRoute: onGenerateRoute,
      home: SplashScreen(),
    );
  }
}
