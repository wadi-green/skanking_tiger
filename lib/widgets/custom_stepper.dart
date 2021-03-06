import 'dart:math';

import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../custom_painters/quadrant_border_painter.dart';
import 'radial_glow.dart';

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
  })  : assert(steps != null),
        assert(titleStyle != null),
        assert(subtitleStyle != null),
        super(key: key);

  final List<CustomStep> steps;
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
            textAlign: index.isEven ? TextAlign.start : TextAlign.end,
            child: steps[index].title,
          ),
          if (steps[index].subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: DefaultTextStyle(
                style: subtitleStyle,
                textAlign: index.isEven ? TextAlign.start : TextAlign.end,
                child: steps[index].subtitle,
              ),
            ),
        ],
      );

  Widget _buildVerticalHeader(int index) {
    const hMargin = 8.0;
    final icon = steps[index].onTap == null
        ? Padding(
            padding: const EdgeInsets.all(hMargin),
            child: steps[index].icon,
          )
        : _NudgingIcon(
            isLeft: index.isEven,
            hMargin: hMargin,
            radius: steps[index].icon.radius,
            icon: steps[index].icon,
          );

    return InkWell(
      onTap: steps[index].onTap,
      child: SizedBox(
        width: double.infinity,
        child: CustomPaint(
          painter: QuadrantBorderPainter(
            topLeft: index.isEven && !_isFirst(index),
            topRight: index.isOdd && !_isFirst(index),
            bottomLeft: index.isEven && !_isLast(index),
            bottomRight: index.isOdd && !_isLast(index),
            borderWidth: 2,
            hMargin: steps[index].icon.radius + hMargin,
            borderColor: steps[index].isCompleted
                ? MainColors.lightGreen
                : MainColors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(children: <Widget>[
              if (index.isEven) ...[
                icon,
                const SizedBox(width: hMargin * 0.75)
              ] else
                const SizedBox(width: hMargin),
              Flexible(child: _buildHeaderText(index)),
              if (index.isOdd) ...[
                const SizedBox(width: hMargin * 0.75),
                icon
              ] else
                const SizedBox(width: hMargin),
            ]),
          ),
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

class _NudgingIcon extends StatefulWidget {
  final Widget icon;
  final double radius, hMargin;
  final bool isLeft;
  const _NudgingIcon({
    Key key,
    @required this.isLeft,
    @required this.icon,
    @required this.radius,
    @required this.hMargin,
  }) : super(key: key);

  @override
  _NudgingIconState createState() => _NudgingIconState();
}

class _NudgingIconState extends State<_NudgingIcon>
    with TickerProviderStateMixin {
  AnimationController _arrowController;
  AnimationController _radialController;
  Animation<double> _animationV;
  Animation<double> _animationH;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _radialController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationV = Tween<double>(begin: 0, end: 16).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    ));
    _animationH = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    ));
    _radialController.repeat();
    Future.delayed(const Duration(milliseconds: 300), () {
      _arrowController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _radialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angle = widget.isLeft ? pi / 3 : 2 * pi / 3;
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: [
        RadialGlow(
          controller: _radialController,
          endRadius: widget.radius + widget.hMargin,
          glowColor: MainColors.lightGreen,
          child: widget.icon,
        ),
        AnimatedBuilder(
          animation: _animationV,
          builder: (context, child) => Positioned(
            top: _animationV.value / 2 - 16,
            right: widget.isLeft ? null : _animationH.value / 2,
            left: widget.isLeft ? _animationH.value / 2 : null,
            child: Transform.rotate(
              angle: angle,
              child: const Icon(
                Icons.arrow_right_alt,
                color: MainColors.darkGrey,
                size: 18,
              ),
            ),
          ),
        )
      ],
    );
  }
}
