import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';

/// Social authentication logic is the same for both login and sign up, so it
/// can be handled in a simple place for more simplicity
class SocialAuthentication extends StatelessWidget {
  final String title;

  const SocialAuthentication({Key key, @required this.title})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      padding: innerEdgeInsets,
      titleSpacing: 14,
      children: [
        buildSocialBtn(
          Strings.continueWithGoogle,
          SvgImages.google,
          SocialColors.google,
          () {},
        ),
        const SizedBox(height: 8),
        buildSocialBtn(
          Strings.continueWithFacebook,
          SvgImages.facebook,
          SocialColors.facebook,
          () {},
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget buildSocialBtn(
      String title, String asset, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                height: 26,
                width: 26,
                child: Center(
                  child: SvgPicture.asset(
                    asset,
                    height: 26,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
