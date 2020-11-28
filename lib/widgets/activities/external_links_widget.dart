import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../data/activity/activity.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';

/// Extracted into a separate widget in order to have the proper context when
/// calling [Scaffold.of(context)]
class ExternalLinksWidget extends StatelessWidget {
  final Activity activity;

  const ExternalLinksWidget({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyText2;
    return CustomCard(
      title: Strings.externalLinks,
      padding: innerEdgeInsets,
      children: [
        for (final link in activity.externalLinks)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(link, style: textTheme),
            trailing: const Text(
              Strings.visit,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              if (await canLaunch(link)) {
                launch(link);
              } else {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text(Strings.cannotLaunchLink),
                  ));
              }
            },
          ),
      ],
    );
  }
}
