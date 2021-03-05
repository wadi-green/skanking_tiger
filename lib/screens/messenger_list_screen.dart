import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../data/chat.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../widgets/chat/messenger_chat_route.dart';
import '../widgets/wadi_scaffold.dart';

class MessengerListScreen extends StatefulWidget {
  static const route = '/messenger/list';
  final bool isMain;
  const MessengerListScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  _MessengerListScreenState createState() => _MessengerListScreenState();
}

class _MessengerListScreenState extends State<MessengerListScreen> {
  String _query;
  // TODO uncomment to activate
  // String _userId;
  String _userAvatar;
  // TODO uncomment to activate
  // Future<List<Chat>> _chats;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthModel>().user;
    _userAvatar = user.picture;
    // TODO uncomment to activate
    // _userId = user.id;=
    // _chats = context.read<Api>().fetchAllGroups(_userId);
  }

  Widget get searchField => TextField(
        onChanged: (val) => setState(() => _query = val),
        autofocus: _showSearch && _query == null,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70),
          hintText: Strings.search,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: Column(
        children: [
          AppBar(
            backgroundColor: MainColors.primary,
            title: _showSearch ? searchField : null,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: CachedNetworkImageProvider(_userAvatar),
              ),
            ),
            actions: [
              if (_showSearch)
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _query = null;
                    setState(() => _showSearch = false);
                  },
                )
              else
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO uncomment to activate
                    // setState(() => _showSearch = true);
                  },
                )
            ],
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Messages are coming soon. Stay tuned!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
          // TODO uncomment to activate
          // Expanded(
          //   child: AdvancedFutureBuilder<List<Chat>>(
          //     future: _chats,
          //     builder: buildChats,
          //     onRefresh: () {
          //       setState(() {
          //         _chats = context.read<Api>().fetchAllGroups(_userId);
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildChats(List<Chat> chats) {
    final formatter = DateFormat('HH:mm');
    final captionStyle = Theme.of(context).textTheme.caption;
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, i) {
        final chat = chats[i];
        if (_query == null ||
            chat.friendName.toLowerCase().contains(_query.toLowerCase())) {
          return ListTile(
            isThreeLine: true,
            onTap: () => Navigator.push(context, MessengerChatRoute(chat)),
            title: Row(
              children: [
                Expanded(child: Text(chat.friendName)),
                Text(
                  formatter.format(chat.lastMessageTime),
                  style: captionStyle,
                ),
              ],
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(chat.friendAvatar),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
