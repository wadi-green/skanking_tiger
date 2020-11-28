import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../utils/strings.dart';
import '../utils/validators.dart';
import 'auth/auth_button.dart';
import 'custom_card.dart';

class BugReportForm extends StatefulWidget {
  const BugReportForm({Key key}) : super(key: key);

  @override
  _BugReportFormState createState() => _BugReportFormState();
}

class _BugReportFormState extends State<BugReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  // Allows us to have a way to dismiss focus on submit while also dismissing
  // the focus node properly instead of creating a node on spot
  final _focusDismiss = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController?.dispose();
    _detailsController?.dispose();
    _focusDismiss.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 12);
    return Form(
      key: _formKey,
      child: CustomCard(
        title: Strings.reportABug,
        padding: innerEdgeInsets,
        children: [
          TextFormField(
            controller: _titleController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            validator: (val) => Validators.required(val, Strings.title),
            decoration: const InputDecoration(
              hintText: Strings.title,
              prefixIcon: Icon(Icons.bug_report_outlined),
            ),
          ),
          spacer,
          TextFormField(
            controller: _detailsController,
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 7,
            validator: (val) => Validators.required(val, Strings.bugDetails),
            decoration: const InputDecoration(
              hintText: Strings.explainTheBug,
            ),
          ),
          spacer,
          spacer,
          Row(
            children: [
              AuthButton(
                title: Strings.report,
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
    _titleController.clear();
    _detailsController.clear();
    FocusScope.of(context).requestFocus(_focusDismiss);
  }

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      try {
        await Future.delayed(const Duration(seconds: 2));
        // TODO api call
        _clearFields();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(Strings.bugReported),
            content: const Text(Strings.thankYouForReporting),
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
