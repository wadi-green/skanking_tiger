import 'package:flutter/material.dart';

/// Modified version of the package https://pub.dev/packages/avatar_glow
/// The modification aims to use our own controller to sync this animation with
/// the arrow movement
class RadialGlow extends StatefulWidget {
  final Widget child;
  final double endRadius;
  final BoxShape shape;
  final Curve curve;
  final bool showTwoGlows;
  final Color glowColor;
  final AnimationController controller;

  const RadialGlow({
    Key key,
    @required this.child,
    @required this.endRadius,
    @required this.controller,
    this.shape = BoxShape.circle,
    this.curve = Curves.fastOutSlowIn,
    this.showTwoGlows = true,
    this.glowColor = Colors.white,
  }) : super(key: key);

  @override
  _RadialGlowState createState() => _RadialGlowState();
}

class _RadialGlowState extends State<RadialGlow>
    with SingleTickerProviderStateMixin {
  Animation<double> smallDiscAnimation;
  Animation<double> bigDiscAnimation;
  Animation<double> alphaAnimation;

  @override
  void initState() {
    super.initState();
    _createAnimation();
  }

  void _createAnimation() {
    final Animation<double> curve = CurvedAnimation(
      parent: widget.controller,
      curve: widget.curve,
    );

    smallDiscAnimation = Tween(
      begin: (widget.endRadius * 2) / 6,
      end: (widget.endRadius * 2) * (3 / 4),
    ).animate(curve);

    bigDiscAnimation = Tween(
      begin: 0.0,
      end: widget.endRadius * 2,
    ).animate(curve);

    alphaAnimation = Tween(begin: 0.30, end: 0.0).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: alphaAnimation,
      builder: (context, widgetChild) {
        final decoration = BoxDecoration(
          shape: widget.shape,
          // If the user picks a curve that goes below 0 or above 1
          // this opacity will have unexpected effects without clamping
          color: widget.glowColor
              .withOpacity(alphaAnimation.value.clamp(0.0, 1.0).toDouble()),
        );

        return SizedBox(
          height: widget.endRadius * 2,
          width: widget.endRadius * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: bigDiscAnimation,
                builder: (context, widget) {
                  // If the user picks a curve that goes below 0,
                  // this will throw without clamping
                  final size = bigDiscAnimation.value
                      .clamp(0.0, double.infinity)
                      .toDouble();

                  return Container(
                    height: size,
                    width: size,
                    decoration: decoration,
                  );
                },
              ),
              if (widget.showTwoGlows)
                AnimatedBuilder(
                  animation: smallDiscAnimation,
                  builder: (context, widget) {
                    final size = smallDiscAnimation.value
                        .clamp(0.0, double.infinity)
                        .toDouble();

                    return Container(
                      height: size,
                      width: size,
                      decoration: decoration,
                    );
                  },
                ),
              widgetChild,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
