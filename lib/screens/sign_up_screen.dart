import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../utils/strings.dart';
import '../widgets/auth/sign_up_form.dart';
import '../widgets/auth/social_authentication.dart';
import '../widgets/wadi_scaffold.dart';

class SignUpScreen extends StatelessWidget {
  static const route = '/sign-up';
  final bool isMain;
  const SignUpScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: Column(
            children: const [
              SocialAuthentication(title: Strings.socialMediaSignUp),
              SizedBox(height: 12),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
