import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../core/text_styles.dart';
import '../data/planter_notification.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/custom_card.dart';
import '../widgets/wadi_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  static const route = '/notifications';
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String planterId;
  Future<List<PlanterNotification>> _notifications;

  @override
  void initState() {
    super.initState();
    planterId = context.read<AuthModel>().user.id;
    _notifications = context.read<Api>().fetchPlanterNotifications(planterId);
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: CustomCard(
            title: Strings.notifications,
            padding: innerEdgeInsets,
            children: [
              AdvancedFutureBuilder<List<PlanterNotification>>(
                future: _notifications,
                builder: buildNotifications,
                onRefresh: () {
                  setState(() {
                    _notifications = context
                        .read<Api>()
                        .fetchPlanterNotifications(planterId);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotifications(List<PlanterNotification> notifications) {
    final textTheme = Theme.of(context).textTheme;
    final children = [
      for (final notification in notifications) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: MainColors.blue,
              radius: 18,
              child: Icon(notification.iconData, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.timeFormatted, style: textTheme.caption),
                  const SizedBox(height: 4),
                  Text(notification.title, style: boxCardItemTitle(context)),
                  const SizedBox(height: 4),
                  Text(notification.message),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
      ]
    ];
    if (children.isNotEmpty) {
      // Remove the last sized box since it's not separating anything
      children.removeLast();
    }
    return Column(children: children);
  }
}
