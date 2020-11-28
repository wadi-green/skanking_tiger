import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/planter.dart';
import '../models/auth_model.dart';
import 'member_screen.dart';

/// Wrapper around the [MemberScreen] that provides the currently authenticated
/// user as the member to display
class MyActivitiesScreen extends StatelessWidget {
  static const route = '/my-activities';
  final bool isMain;

  const MyActivitiesScreen({Key key, this.isMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AuthModel, Planter>(
      selector: (context, model) => model.user,
      builder: (context, currentUser, child) => MemberScreen(
        isMain: isMain,
        fetchMemberCallback: () => Future<Planter>.value(currentUser),
      ),
    );
  }
}
