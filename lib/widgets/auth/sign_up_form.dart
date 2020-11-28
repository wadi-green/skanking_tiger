import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../data/route_arguments.dart';
import '../../screens/log_in_screen.dart';
import '../../utils/strings.dart';
import '../../utils/validators.dart';
import '../../utils/wadi_green_icons.dart';
import '../custom_card.dart';
import 'auth_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmationController = TextEditingController();
  // Allows us to have a way to dismiss focus on submit while also dismissing
  // the focus node properly instead of creating a node on spot
  final _focusDismiss = FocusNode();
  bool isAgreed = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController?.dispose();
    passController?.dispose();
    passConfirmationController?.dispose();
    _focusDismiss?.dispose();
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
            validator: (val) =>
                Validators.required(val, Strings.password) ??
                Validators.password(val),
            decoration: const InputDecoration(
              hintText: Strings.password,
              prefixIcon: Icon(WadiGreenIcons.key, size: 10),
            ),
          ),
          spacer,
          TextFormField(
            controller: passConfirmationController,
            obscureText: true,
            validator: (val) =>
                Validators.required(val, Strings.passwordConfirmation) ??
                Validators.passwordConfirmation(val, passController.text),
            decoration: const InputDecoration(
              hintText: Strings.confirmPassword,
              prefixIcon: Icon(WadiGreenIcons.key, size: 10),
            ),
          ),
          spacer,
          InkWell(
            onTap: () => setState(() => isAgreed = !isAgreed),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (val) => setState(() => isAgreed = val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '${Strings.iAgreeTo} ',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: MainColors.black),
                      children: const [
                        TextSpan(
                          text: Strings.termsAndConditions,
                          style: TextStyle(color: MainColors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          spacer,
          AuthButton(
            title: Strings.signUp,
            isLoading: isLoading,
            onPressed: submit,
          ),
          spacer,
          RichText(
            text: TextSpan(
              text: '${Strings.alreadyAMember} ',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: MainColors.black),
              children: [
                TextSpan(
                  text: Strings.login,
                  style: const TextStyle(color: MainColors.lightGreen),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushReplacementNamed(
                        LogInScreen.route,
                        arguments: const RouteArguments(isMain: true),
                      );
                    },
                ),
              ],
            ),
          ),
          spacer,
        ],
      ),
    );
  }

  void _clearFields() {
    emailController.clear();
    passController.clear();
    passConfirmationController.clear();
    FocusScope.of(context).requestFocus(_focusDismiss);
  }

  Future<void> submit() async {
    if (!isAgreed) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(Strings.pleaseAgreeToTerms)),
        );
      return;
    }
    if (formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        await context
            .read<Api>()
            .signUp(emailController.text, passController.text);
        _clearFields();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(Strings.signUpSuccessful),
            content: const Text(Strings.signUpCheckEmail),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ],
          ),
        );
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
