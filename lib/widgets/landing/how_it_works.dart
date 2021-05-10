import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/colors.dart';
import '../../core/images.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({Key key}) : super(key: key);

  @override
  _HowItWorksState createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  int _currentStep = 0;

  Widget buildIcon(String icon, double width, int index) {
    final isCompleted = _currentStep >= index;
    return GestureDetector(
      onTap: () {
        if (_currentStep == index - 1) {
          setState(() => _currentStep = index);
        }
      },
      child: CircleAvatar(
        backgroundColor:
            isCompleted ? MainColors.lightGreen : MainColors.lightGrey,
        radius: width / 2,
        child: SvgPicture.asset(
          icon,
          width: width * 0.6,
          color: isCompleted ? MainColors.white : MainColors.black,
        ),
      ),
    );
  }

  Widget buildText(String text, double width) => SizedBox(
        width: width,
        child: Text(text, textAlign: TextAlign.center),
      );

  // Divide the bar behind the circle to 5 sections, and fill until
  // current + spaces between + 0.5
  double get computeCompleted {
    switch (_currentStep) {
      case 0:
        return 0;
      case 1:
        return 1.5;
      case 2:
        return 3.5;
      case 3:
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.howItWorks,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // each circle is 1/5 of the total horizontal space
              final iconWidth = constraints.maxWidth * 0.2;
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: computeCompleted / 5,
                        backgroundColor: const Color(0xffa6a6a6),
                        valueColor: const AlwaysStoppedAnimation(
                          MainColors.lightGreen,
                        ),
                        minHeight: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildIcon(SvgImages.eye, iconWidth, 1),
                          buildIcon(SvgImages.like, iconWidth, 2),
                          buildIcon(SvgImages.plantHand, iconWidth, 3),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildText('Find an Activity', iconWidth),
                      buildText('Do Steps', iconWidth),
                      buildText('Earn Karma', iconWidth),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          launch('https://www.wadi.green/landing_page/about.html'),
                      child: const Text(Strings.readMore),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
