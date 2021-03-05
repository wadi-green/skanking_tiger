import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../custom_painters/quadrant_border_painter.dart';

@immutable
class CustomStep {
  const CustomStep({
    @required this.title,
    @required this.icon,
    this.isCompleted = false,
    this.subtitle,
    this.onTap,
  });

  final Widget title;
  final CircleAvatar icon;
  final Widget subtitle;
  final VoidCallback onTap;
  final bool isCompleted;
}

/// This Stepper is based on the original [Stepper] from the material widgets.
/// It removes all the unneeded complexities and keeps only the things necessary
/// for our own needs. In addition to that, it adds the alternating left-right
/// pattern with the wavy curves that are drawn using the [QuadrantBorderPainter]
class CustomStepper extends StatelessWidget {
  const CustomStepper({
    Key key,
    @required this.steps,
    @required this.titleStyle,
    @required this.subtitleStyle,
    this.lineHeight = 16.0,
  })  : assert(steps != null),
        assert(titleStyle != null),
        assert(subtitleStyle != null),
        super(key: key);

  final List<CustomStep> steps;
  final double lineHeight;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  bool _isFirst(int index) => index == 0;

  bool _isLast(int index) => steps.length - 1 == index;

  Widget _buildHeaderText(int index) => Column(
        crossAxisAlignment:
            index.isEven ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DefaultTextStyle(
            style: titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: steps[index].title,
          ),
          if (steps[index].subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: DefaultTextStyle(
                style: subtitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: steps[index].subtitle,
              ),
            ),
        ],
      );

  Widget _buildVerticalHeader(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: steps[index].onTap,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: steps[index].icon.radius,
              ),
              child: SizedBox(
                height: steps[index].icon.radius * 2 + lineHeight * 2,
                width: double.infinity,
                child: CustomPaint(
                  painter: QuadrantBorderPainter(
                    topLeft: index.isEven && !_isFirst(index),
                    topRight: index.isOdd && !_isFirst(index),
                    bottomLeft: index.isEven && !_isLast(index),
                    bottomRight: index.isOdd && !_isLast(index),
                    borderWidth: 2,
                    borderColor: steps[index].isCompleted
                        ? MainColors.lightGreen
                        : MainColors.darkGrey,
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                if (index.isEven)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: lineHeight),
                    child: steps[index].icon,
                  )
                else
                  const Spacer(),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildHeaderText(index),
                  ),
                ),
                if (index.isOdd)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: lineHeight),
                    child: steps[index].icon,
                  )
                else
                  const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < steps.length; i += 1) _buildVerticalHeader(i)
      ],
    );
  }
}
