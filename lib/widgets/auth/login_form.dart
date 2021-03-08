import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../data/route_arguments.dart';
import '../../models/auth_model.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/sign_up_screen.dart';
import '../../utils/strings.dart';
import '../../utils/validators.dart';
import '../../utils/wadi_green_icons.dart';
import '../custom_card.dart';
import 'auth_button.dart';

class LoginForm extends StatefulWidget {
  final bool isMain;
  const LoginForm({Key key, @required this.isMain}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool rememberMe = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController?.dispose();
    passController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 12);
    return Form(
      key: formKey,
      child: CustomCard(
        title: Strings.credentials,
        padding: innerEdgeInsets,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) =>
                Validators.required(val, Strings.email) ??
                Validators.email(val),
            decoration: const InputDecoration(
              hintText: Strings.email,
              prefixIcon: Icon(WadiGreenIcons.mail, size: 14),
            ),
          ),
          spacer,
          TextFormField(
            controller: passController,
            obscureText: true,
            validator: (val) => Validators.required(val, Strings.password),
            decoration: const InputDecoration(
              hintText: Strings.password,
              prefixIcon: Icon(WadiGreenIcons.key, size: 10),
            ),
          ),
          spacer,
          spacer,
          AuthButton(
            title: Strings.login,
            isLoading: isLoading,
            onPressed: submit,
          ),
          spacer,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => rememberMe = !rememberMe),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (val) => setState(() => rememberMe = val),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          Strings.keepMeLoggedIn,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: MainColors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  // TODO
                },
                child: Text(
                  Strings.forgotPassword,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: MainColors.lightGreen),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RichText(
              text: TextSpan(
                text: '${Strings.noAccount} ',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: MainColors.black),
                children: [
                  TextSpan(
                    text: Strings.signUp,
                    style: const TextStyle(color: MainColors.lightGreen),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed(
                          SignUpScreen.route,
                          arguments: const RouteArguments(isMain: true),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
          spacer,
        ],
      ),
    );
  }

  Future<void> submit() async {
    if (formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        final api = context.read<Api>();
        final response =
            await api.login(emailController.text, passController.text);
        final planter = await api.fetchPlanter(response.planterId);
        context.read<AuthModel>().login(response, planter, persist: rememberMe);
        if (widget.isMain) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            DashboardScreen.route,
            (route) => false,
            arguments: const RouteArguments(isMain: true),
          );
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
