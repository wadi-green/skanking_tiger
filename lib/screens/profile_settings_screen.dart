import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../data/planter.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../utils/validators.dart';
import '../utils/wadi_green_icons.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/wadi_scaffold.dart';

class ProfileSettingsScreen extends StatefulWidget {
  static const route = '/profile/settings';
  final bool isMain;
  const ProfileSettingsScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _cityController = TextEditingController();
  final _favActivitiesController = TextEditingController();
  final _focusDismiss = FocusNode();
  // The user is saved here and used to restore original data on cancel
  Planter _user;
  File _image;
  String _country;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthModel>().user;
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _aboutController.text = _user.aboutMe;
    _favActivitiesController.text = _user.favoriteActivities;
    _country = countries.contains(_user.country) ? _user.country : null;
    _cityController.text = _user.city;
  }

  @override
  void dispose() {
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _aboutController?.dispose();
    _cityController?.dispose();
    _favActivitiesController?.dispose();
    _focusDismiss?.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        final pathToImage = await context.read<Api>().uploadProfilePicture(
              context.read<AuthModel>().user.id,
              _image,
              context.read<AuthModel>().tokenData.accessToken,
            );
        final updatedUser = _user.copyWith(
          picture: '$pathToImage?date=${DateTime.now().millisecondsSinceEpoch}',
        );
        context.read<AuthModel>().updateUser(updatedUser);
        _user = updatedUser;
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  void resetFields() {
    FocusScope.of(context).requestFocus(_focusDismiss);
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _aboutController.text = _user.aboutMe;
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusDismiss);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: wrapEdgeInsets,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildBasicInfo(),
                  const SizedBox(height: 12),
                  buildLocation(),
                  const SizedBox(height: 12),
                  buildFavoriteActivities(),
                  const SizedBox(height: 12),
                  buildPreferences(),
                  const SizedBox(height: 12),
                  buildAccountSettings(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBasicInfo() => CustomCard(
        title: Strings.basicInformation,
        padding: wrapEdgeInsets,
        children: [
          TextFormField(
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (val) => Validators.required(val, Strings.fullName),
            decoration: const InputDecoration(
              hintText: Strings.fullName,
              prefixIcon: Icon(WadiGreenIcons.userCircle, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _lastNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (val) => Validators.required(val, Strings.fullName),
            decoration: const InputDecoration(
              hintText: Strings.fullName,
              prefixIcon: Icon(WadiGreenIcons.userCircle, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: getImage,
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: Strings.profilePhoto,
                  contentPadding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: (_image == null
                          ? CachedNetworkImageProvider(_user.picture)
                          : FileImage(_image)) as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _aboutController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: Strings.aboutYourself,
            ),
          ),
        ],
      );

  Widget buildLocation() => CustomCard(
        title: Strings.location,
        padding: wrapEdgeInsets,
        children: [
          DropdownButtonFormField<String>(
            value: _country,
            selectedItemBuilder: (_) => countries
                .map((c) =>
                    Text(c, maxLines: 1, overflow: TextOverflow.ellipsis))
                .toList(),
            onChanged: (country) => setState(() => _country = country),
            isExpanded: true,
            items: countries.map<DropdownMenuItem<String>>((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            iconSize: 22,
            icon: const Icon(CupertinoIcons.chevron_down, size: 22),
            decoration: const InputDecoration(
              hintText: Strings.chooseCountry,
              alignLabelWithHint: true,
              suffix: SizedBox(width: 6),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cityController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(hintText: Strings.city),
          ),
        ],
      );

  Widget buildFavoriteActivities() => CustomCard(
        title: Strings.favoriteActivities,
        padding: wrapEdgeInsets,
        children: [
          TextFormField(
            controller: _favActivitiesController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 150,
            decoration: const InputDecoration(
              hintText: Strings.favoriteActivitiesHint,
              counter: SizedBox(),
            ),
          ),
        ],
      );

  Widget buildPreferences() => CustomCard(
        title: Strings.preferences,
        padding: wrapEdgeInsets,
        children: [
          DropdownButtonFormField<String>(
            value: 'English',
            onChanged: null,
            isExpanded: true,
            disabledHint: const Text('English'),
            items: ['English'].map<DropdownMenuItem<String>>((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            iconSize: 22,
            icon: const Icon(CupertinoIcons.chevron_down, size: 22),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              suffix: const SizedBox(width: 6),
              helperText: Strings.languagesComingSoon,
            ),
          ),
        ],
      );

  Widget buildAccountSettings() {
    final textStyle = Theme.of(context)
        .textTheme
        .caption
        .copyWith(color: MainColors.lightGreen);
    return CustomCard(
      title: Strings.accountSettings,
      padding: wrapEdgeInsets,
      children: [
        GestureDetector(
          onTap: showChangePasswordDialog,
          child: Text(Strings.changePassword, style: textStyle),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(Strings.closeAccount),
                content: const Text(Strings.closeAccountConfirmation),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    textColor: Colors.red,
                    child: const Text(Strings.cancel),
                  ),
                  // TODO send request
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(Strings.yes),
                  ),
                ],
              ),
            );
          },
          child: Text(Strings.closeAccount, style: textStyle),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Builder(
              builder: (context) => AuthButton(
                title: Strings.save,
                isLoading: _isLoading,
                // The context is passed in order to properly display the snackbars
                onPressed: () => submit(context),
              ),
            ),
            FlatButton(
              onPressed: resetFields,
              child: Text(
                MaterialLocalizations.of(context).cancelButtonLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<void> submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        await Future.delayed(const Duration(seconds: 2));
        final updatedUser = _user.copyWith(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          aboutMe: _aboutController.text,
          city: _cityController.text,
          country: _country,
          favoriteActivities: _favActivitiesController.text,
        );
        await context.read<Api>().updatePlanter(
              context.read<AuthModel>().user.id,
              updatedUser,
              context.read<AuthModel>().tokenData.accessToken,
            );
        context.read<AuthModel>().updateUser(updatedUser);
        _user = updatedUser;
        resetFields();
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text(Strings.profileUpdated)));
      } catch (e) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text(Strings.changePassword),
        content: _ChangePasswordDialog(),
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({Key key}) : super(key: key);

  @override
  __ChangePasswordDialogState createState() => __ChangePasswordDialogState();
}

class __ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPassController?.dispose();
    _passController?.dispose();
    _passConfirmationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 12);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _oldPassController,
            obscureText: true,
            validator: (val) => Validators.required(val, Strings.oldPassword),
            decoration: const InputDecoration(
              hintText: Strings.oldPassword,
            ),
          ),
          spacer,
          TextFormField(
            controller: _passController,
            obscureText: true,
            validator: (val) =>
                Validators.required(val, Strings.newPassword) ??
                Validators.password(val),
            decoration: const InputDecoration(
              hintText: Strings.newPassword,
            ),
          ),
          spacer,
          TextFormField(
            controller: _passConfirmationController,
            obscureText: true,
            validator: (val) =>
                Validators.required(val, Strings.passwordConfirmation) ??
                Validators.passwordConfirmation(val, _passController.text),
            decoration: const InputDecoration(
              hintText: Strings.confirmPassword,
            ),
          ),
          spacer,
          spacer,
          Row(
            children: [
              AuthButton(
                title: Strings.save,
                isLoading: _isLoading,
                onPressed: submit,
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
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

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        // TODO api request
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text(Strings.passwordChanged)),
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
