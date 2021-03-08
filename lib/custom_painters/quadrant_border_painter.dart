import 'package:flutter/material.dart';

import '../core/colors.dart';

/// Draws a border only on the specified quadrants
class QuadrantBorderPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  final Color borderColor;
  final double borderWidth;
  final double hMargin;

  QuadrantBorderPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    this.borderColor = MainColors.grey,
    this.borderWidth = 1,
    this.hMargin = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width - hMargin * 2;
    final h = size.height;

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (topLeft) {
      final topLeftPath = Path()
        ..moveTo(hMargin, h / 2)
        ..lineTo(hMargin, h / 4)
        ..quadraticBezierTo(hMargin, 0, hMargin + h / 4, 0)
        ..lineTo(hMargin + w / 2, 0);
      canvas.drawPath(topLeftPath, paint);
    }

    if (topRight) {
      final topRightPath = Path()
        ..moveTo(hMargin + w, h / 2)
        ..lineTo(hMargin + w, h / 4)
        ..quadraticBezierTo(hMargin + w, 0, hMargin + w - (h / 4), 0)
        ..lineTo(hMargin + w / 2, 0);
      canvas.drawPath(topRightPath, paint);
    }

    if (bottomLeft) {
      final bottomLeftPath = Path()
        ..moveTo(hMargin, h / 2)
        ..lineTo(hMargin, h * 0.75)
        ..quadraticBezierTo(hMargin, h, hMargin + h / 4, h)
        ..lineTo(hMargin + w / 2, h);
      canvas.drawPath(bottomLeftPath, paint);
    }

    if (bottomRight) {
      final bottomRightPath = Path()
        ..moveTo(hMargin + w, h / 2)
        ..lineTo(hMargin + w, h * 0.75)
        ..quadraticBezierTo(hMargin + w, h, hMargin + w - (h / 4), h)
        ..lineTo(hMargin + w / 2, h);
      canvas.drawPath(bottomRightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
