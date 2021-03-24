import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../data/chat.dart';
import '../../data/planter.dart';
import '../../data/route_arguments.dart';
import '../../models/auth_model.dart';
import '../../screens/plant_canvas_screen.dart';
import '../../utils/strings.dart';
import '../chat/messenger_chat_route.dart';

class PlanterActions extends StatefulWidget {
  final Planter member;
  const PlanterActions({Key key, @required this.member}) : super(key: key);

  @override
  _PlanterActionsState createState() => _PlanterActionsState();
}

class _PlanterActionsState extends State<PlanterActions> {
  bool _isFriend = false;

  @override
  void initState() {
    super.initState();
    if (context.read<AuthModel>().user?.id != widget.member.id) {
      initFriendshipStatus();
    }
  }

  Future<void> initFriendshipStatus() async {
    try {
      final authModel = context.read<AuthModel>();
      // todo : Directly fetch friend instead of all friends. Api is missing as of now
      final friends = await context.read<Api>().fetchPlanterFriends(
            authModel.user.id,
            20
          );
      setState(() {
        _isFriend = friends.any((f) => f.id == widget.member.id);
      });
    } catch (e, tr) {
      debugPrint(tr.toString());
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> addFriend() async {
    try {
      final authModel = context.read<AuthModel>();
      await context.read<Api>().addFriend(
            authModel.user.id,
            widget.member.id,
            authModel.tokenData.accessToken,
          );
      setState(() => _isFriend = !_isFriend);
    } catch (e, tr) {
      debugPrint(tr.toString());
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, authModel, child) {
      if (!authModel.isLoggedIn) return const SizedBox(height: 12);

      final btnPadding = MaterialStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ));

      return ButtonBar(
        alignment: MainAxisAlignment.end,
        buttonPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        children: [
          ElevatedButton(
            style: ButtonStyle(padding: btnPadding),
            onPressed: () {
              Navigator.of(context).pushNamed(
                PlantCanvasScreen.route,
                arguments: RouteArguments(data: {
                  PlantCanvasScreen.planterIdArg: widget.member.id,
                }),
              );
            },
            child: const Text(Strings.viewPlants),
          ),
          if (authModel.user?.id != widget.member.id) ...[
            ElevatedButton(
              style: ButtonStyle(padding: btnPadding),
              onPressed: () {
                Navigator.of(context).push(MessengerChatRoute(
                  Chat.fromPlanter(widget.member),
                ));
              },
              child: const Text(Strings.message),
            ),
            ElevatedButton(
              style: ButtonStyle(
                padding: btnPadding,
                backgroundColor: MaterialStateProperty.all(
                  _isFriend ? MainColors.lightGreen : MainColors.primary,
                ),
              ),
              onPressed: addFriend,
              child: _isFriend
                  ? const Text(Strings.friends)
                  : const Text(Strings.addFriend),
            ),
          ]
        ],
      );
    });
  }
}
