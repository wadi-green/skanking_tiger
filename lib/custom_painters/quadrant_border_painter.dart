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

  QuadrantBorderPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    this.borderColor = MainColors.darkGrey,
    this.borderWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (topLeft) {
      final topLeftPath = Path()
        ..moveTo(0, h / 2)
        ..lineTo(0, h / 4)
        ..quadraticBezierTo(0, 0, h / 4, 0)
        ..lineTo(w / 2, 0);
      canvas.drawPath(topLeftPath, paint);
    }

    if (topRight) {
      final topRightPath = Path()
        ..moveTo(w, h / 2)
        ..lineTo(w, h / 4)
        ..quadraticBezierTo(w, 0, w - (h / 4), 0)
        ..lineTo(w / 2, 0);
      canvas.drawPath(topRightPath, paint);
    }

    if (bottomLeft) {
      final bottomLeftPath = Path()
        ..moveTo(0, h / 2)
        ..lineTo(0, h * 0.75)
        ..quadraticBezierTo(0, h, h / 4, h)
        ..lineTo(w / 2, h);
      canvas.drawPath(bottomLeftPath, paint);
    }

    if (bottomRight) {
      final bottomRightPath = Path()
        ..moveTo(w, h / 2)
        ..lineTo(w, h * 0.75)
        ..quadraticBezierTo(w, h, w - (h / 4), h)
        ..lineTo(w / 2, h);
      canvas.drawPath(bottomRightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
