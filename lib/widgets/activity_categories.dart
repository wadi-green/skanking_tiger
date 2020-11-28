import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/activity_category.dart';
import '../utils/strings.dart';
import 'custom_card.dart';
import 'grids/grid_box_item.dart';

class ActivityCategories extends StatelessWidget {
  final String title;
  final void Function(String) onPressed;
  final List<ActivityCategory> categories;
  final VoidCallback onViewAll;

  const ActivityCategories({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.categories,
    this.onViewAll,
  })  : assert(title != null),
        assert(onPressed != null),
        assert(categories != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: categories.length,
          gridDelegate: defaultGridDelegate,
          itemBuilder: (context, i) => GridBoxItem(
            title: categories[i].name,
            imgUrl: categories[i].image,
            onPressed: () => onPressed?.call(categories[i].name),
          ),
        ),
        if (onViewAll != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onViewAll,
              child: const Text(Strings.viewAll),
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }
}
