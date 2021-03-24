import 'package:flutter/material.dart';
import '../../screens/sign_up_screen.dart';

import '../../utils/strings.dart';
import '../custom_card.dart';

class LandingCallToAction extends StatelessWidget {
  const LandingCallToAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.startGrowingYourPlants,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SignUpScreen.route);
            },
            child: const Text(
              Strings.becomeAPlanter,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
