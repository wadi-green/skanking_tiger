import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/friend_invitation_form.dart';
import '../widgets/wadi_scaffold.dart';

class InvitationFormScreen extends StatelessWidget {
  static const route = '/invitation-form';
  final bool isMain;
  const InvitationFormScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: Column(
            children: const [
              FriendInvitationForm(),
            ],
          ),
        ),
      ),
    );
  }
}
