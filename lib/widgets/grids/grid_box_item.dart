import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/text_styles.dart';
import '../common.dart';

class GridBoxItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final VoidCallback onPressed;

  const GridBoxItem({
    Key key,
    @required this.title,
    @required this.imgUrl,
    @required this.onPressed,
  })  : assert(title != null),
        assert(imgUrl != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            child: AspectRatio(
              aspectRatio: 1, // Square image
              child: InkWell(
                onTap: onPressed,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  placeholder: (_, __) => loadingImagePlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, maxLines: 1, style: boxCardItemTitle(context)),
      ],
    );
  }
}
