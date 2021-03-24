import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../custom_card.dart';

class HashtagsWidget extends StatelessWidget {
  final String title;
  final void Function(String) onPressed;
  final List<String> hashtags;
  final String subtitle;

  const HashtagsWidget({
    Key key,
    this.subtitle,
    @required this.title,
    @required this.onPressed,
    @required this.hashtags,
  })  : assert(hashtags != null),
        assert(title != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Text(
          subtitle,
          style: searchSubtitle(context),
        ),
        Wrap(
          runSpacing: -4,
          spacing: 12,
          children: hashtags
              .map((h) => ActionChip(
                    backgroundColor: MainColors.blue,
                    elevation: 2,
                    shadowColor: MainColors.lightGreen,
                    label: Text(h, style: const TextStyle(color: Colors.white)),
                    onPressed: () => onPressed?.call(h),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
