import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/bug_report_form.dart';
import '../widgets/wadi_scaffold.dart';

class ReportBugScreen extends StatelessWidget {
  static const route = '/report-bug';
  final bool isMain;
  const ReportBugScreen({Key key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: isMain,
      body: SingleChildScrollView(
        child: Padding(
          padding: wrapEdgeInsets,
          child: Column(
            children: const [
              BugReportForm(),
            ],
          ),
        ),
      ),
    );
  }
}
