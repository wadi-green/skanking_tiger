import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../custom_card.dart';

class ActivityStatsWidget extends StatelessWidget {
  final String title;
  final num stat;
  final Widget icon;

  const ActivityStatsWidget({
    Key key,
    @required this.title,
    @required this.stat,
    this.icon,
  })  : assert(title != null),
        assert(stat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      titleSpacing: 0,
      padding: innerEdgeInsets,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 12),
            ],
            Text(
              '$stat',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ],
    );
  }
}
