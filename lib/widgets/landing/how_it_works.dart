import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/colors.dart';
import '../../core/images.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({Key key}) : super(key: key);

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
                      Container(
                        color: MainColors.grey,
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: MainColors.lightGrey,
                            radius: iconWidth / 2,
                            child: SvgPicture.asset(
                              SvgImages.eye,
                              width: iconWidth * 0.6,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: MainColors.lightGrey,
                            radius: iconWidth / 2,
                            child: SvgPicture.asset(
                              SvgImages.like,
                              width: iconWidth * 0.6,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: MainColors.lightGrey,
                            radius: iconWidth / 2,
                            child: SvgPicture.asset(
                              SvgImages.plantHand,
                              width: iconWidth * 0.6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: iconWidth,
                        child: const Text(
                          'Step 1',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: iconWidth,
                        child: const Text(
                          'Step 2',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: iconWidth,
                        child: const Text(
                          'Step 3',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
