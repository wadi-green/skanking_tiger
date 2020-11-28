import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/text_styles.dart';
import '../../data/planter.dart';
import '../../utils/strings.dart';
import '../../utils/wadi_green_icons.dart';
import '../common.dart';

class DetailedPlanterTile extends StatelessWidget {
  final Planter planter;
  final VoidCallback onTap;

  const DetailedPlanterTile({Key key, @required this.planter, this.onTap})
      : assert(planter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const height = 140.0;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                imageUrl: planter.picture,
                width: double.infinity,
                fit: BoxFit.cover,
                height: height,
                placeholder: (_, __) => loadingImagePlaceholder,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(planter.fullName, style: boxCardItemTitle(context)),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    child: Text(
                      planter.aboutMe,
                      style: shortDescriptionCaption(context),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.karma,
                        style: detailedTileLabel(context),
                      ),
                      Text(
                        '${planter.karma}',
                        style: detailedTileValue(context),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(children: [
                    Text(
                      Strings.plants,
                      style: detailedTileLabel(context),
                    ),
                    const Spacer(),
                    const SizedBox(width: 4),
                    const FaIcon(WadiGreenIcons.plant, size: 16),
                    const SizedBox(width: 2),
                    const FaIcon(WadiGreenIcons.plant, size: 16),
                    const SizedBox(width: 2),
                    const FaIcon(WadiGreenIcons.plant, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${planter.totalPlants}',
                      style: detailedTileValue(context),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
