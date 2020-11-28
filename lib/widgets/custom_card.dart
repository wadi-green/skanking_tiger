import 'package:flutter/material.dart';

import '../core/text_styles.dart';

/// A full-width card with no elevation and with a custom border radius used
/// for the box sections in the app
class CustomCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;
  final double titleSpacing;

  const CustomCard({
    Key key,
    @required this.children,
    this.title,
    this.titleSpacing = 12,
    this.padding,
  })  : assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = (title == null && children.length == 1)
        ? children.first
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title, style: boxCardTitle(context)),
                SizedBox(height: titleSpacing ?? 12),
              ],
              ...children,
            ],
          );
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: padding == null ? body : Padding(padding: padding, child: body),
      ),
    );
  }
}
