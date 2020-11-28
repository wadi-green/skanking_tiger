import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../utils/strings.dart';
import '../utils/validators.dart';
import '../utils/wadi_green_icons.dart';
import 'auth/auth_button.dart';
import 'custom_card.dart';

class FriendInvitationForm extends StatefulWidget {
  const FriendInvitationForm({Key key}) : super(key: key);

  @override
  _FriendInvitationFormState createState() => _FriendInvitationFormState();
}

class _FriendInvitationFormState extends State<FriendInvitationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  // Allows us to have a way to dismiss focus on submit while also dismissing
  // the focus node properly instead of creating a node on spot
  final _focusDismiss = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _messageController?.dispose();
    _focusDismiss.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 12);
    return Form(
      key: _formKey,
      child: CustomCard(
        title: Strings.inviteAFriend,
        padding: innerEdgeInsets,
        children: [
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (val) => Validators.required(val, Strings.friendName),
            decoration: const InputDecoration(
              hintText: Strings.friendName,
              prefixIcon: Icon(WadiGreenIcons.users, size: 14),
            ),
          ),
          spacer,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) =>
                Validators.required(val, Strings.friendEmail) ??
                Validators.email(val),
            decoration: const InputDecoration(
              hintText: Strings.friendEmail,
              prefixIcon: Icon(WadiGreenIcons.mail, size: 14),
            ),
          ),
          spacer,
          TextFormField(
            controller: _messageController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            validator: (val) => Validators.required(val, Strings.message),
            decoration: const InputDecoration(
              hintText: Strings.pleaseWriteMessage,
            ),
          ),
          spacer,
          spacer,
          Row(
            children: [
              AuthButton(
                title: Strings.send,
                isLoading: _isLoading,
                onPressed: submit,
              ),
              FlatButton(
                onPressed: _clearFields,
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    FocusScope.of(context).requestFocus(_focusDismiss);
  }

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<Api>().inviteFriend(_emailController.text,
            _nameController.text, _messageController.text);
        _clearFields();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(Strings.invitationSent),
            content: const Text(Strings.thankYouForInviting),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ],
          ),
        );
      } catch (e) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
