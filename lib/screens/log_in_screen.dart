import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/auth/login_form.dart';
import '../widgets/wadi_scaffold.dart';

class LogInScreen extends StatelessWidget {
  static const route = '/login';
  final bool isMain;
  const LogInScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: Column(
            children: [
              // const SocialAuthentication(title: Strings.socialMediaLogin),
              const SizedBox(height: 12),
              LoginForm(isMain: isMain),
            ],
          ),
        ),
      ),
    );
  }
}
