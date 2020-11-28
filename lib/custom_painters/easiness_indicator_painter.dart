import 'package:flutter/material.dart';

import '../core/colors.dart';

/// [CustomPainter] used to draw the easiness level indicator.
/// Example usage:
///
/// ```dart
/// SizedBox(
///   width: width,
///   height: height,
///   child: CustomPaint(
///     painter: EasinessIndicatorCustomPainter(
///       value: value,
///       barCount: barCount,
///     ),
///   ),
/// );
/// ```
class EasinessIndicatorPainter extends CustomPainter {
  final num value;
  final int barCount;

  const EasinessIndicatorPainter({
    @required this.value,
    this.barCount = 5,
  })  : assert(value != null),
        assert(barCount > 0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // In case all sections had equal width, this is how much space each one
    // would have
    final sectionWidth = w / barCount;
    // To make the space dynamic, we set it as 20% of the width of each section
    final singleSpacing = 0.2 * sectionWidth;
    // And we always have one space less than the number of bars
    final totalSpacing = (barCount - 1) * singleSpacing;
    // After calculating the width needed for spaces, this is how much we have
    // left for the actual bars
    final spaceLeftForBars = w - totalSpacing;
    // Because we want the first bar to take double the width of other bars,
    // we make the calculations as if we had an extra bar
    final barWidth = spaceLeftForBars / (barCount + 1);

    // An active bar is filled with [MainColors.darkGrey]
    final Paint activeBarPaint = Paint()..color = MainColors.darkGrey;
    // An inactive bar only has a border
    final Paint inactiveBarPaint = Paint()
      ..color = MainColors.darkGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    // draw bars
    for (var i = 1; i <= barCount; i++) {
      // Needed because the first bar has a double width
      final currentBarWidth = i == 1 ? barWidth * 2 : barWidth;
      // first bar always starts at 0. Typically, the offset would be:
      // (i - 1) * (barWidth + singleSpacing) but since the first bar is
      // equivalent to 2 * barWidth  it results in the equation below
      final left = i == 1 ? 0.0 : (i * barWidth + (i - 1) * singleSpacing);
      final right = left + currentBarWidth;

      // tan(alpha) = opp / adj = h / w
      // tan(alpha) = opp / adj = newHeight / newWidth
      // Therefore newHeight = newWidth * h / w
      final topLeft = left * h / w;
      final topRight = right * h / w;

      final paint = value > i - 1 ? activeBarPaint : inactiveBarPaint;

      final bar = Path()
        ..moveTo(left, h - topLeft)
        ..lineTo(right, h - topRight)
        ..lineTo(right, h)
        ..lineTo(left, h)
        ..close();

      canvas.drawPath(bar, paint);
    }
  }

  @override
  bool shouldRepaint(EasinessIndicatorPainter oldDelegate) => true;
}
