import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../api/api_exceptions.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../data/activity/activity.dart';
import '../../data/activity/planter_activity.dart';
import '../../data/activity_step.dart';
import '../../data/checkin_activity_type.dart';
import '../../data/planter_checkin.dart';
import '../../models/auth_model.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';
import '../custom_stepper.dart';

class ActivityStepsWidget extends StatefulWidget {
  final Activity activity;

  const ActivityStepsWidget({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  @override
  _ActivityStepsWidgetState createState() => _ActivityStepsWidgetState();
}

class _ActivityStepsWidgetState extends State<ActivityStepsWidget> {
  final _commentController = TextEditingController();
  bool _isLoading = false;
  PlanterActivity _planterActivity;
  String _error;

  @override
  void initState() {
    super.initState();
    _checkActivityStatus();
  }

  @override
  void dispose() {
    _commentController?.dispose();
    super.dispose();
  }

  Future<void> _checkActivityStatus() async {
    final currentPlanter = context.read<AuthModel>().user;
    final tokenData = context.read<AuthModel>().tokenData;
    if (currentPlanter == null || !currentPlanter.activities.contains(widget.activity.id)) {
      // Do nothing for guest users
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await context
          .read<Api>()
          .fetchPlanterActivity(currentPlanter.id, widget.activity.id, tokenData.accessToken);
      _planterActivity = result;
    } catch (e) {
      if (e is ApiException && e.code == 404) {
        // The planter doesn't have records for this activity, so they can
        // start with the first step
        _planterActivity = PlanterActivity.fromNewActivity(widget.activity);
      } else {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: Strings.retry,
              textColor: Colors.white,
              onPressed: _checkActivityStatus,
            ),
          ));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    widget.activity.steps.sort((a, b) => a.number.compareTo(b.number));
    return CustomCard(
      title: Strings.stepsToComplete,
      padding: innerEdgeInsets,
      children: [
        if (_isLoading)
          const LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: MainColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(MainColors.lightGreen),
          ),
        CustomStepper(
          titleStyle: textTheme.bodyText1,
          subtitleStyle: textTheme.caption,
          steps: widget.activity.steps.map((s) => buildStep(s)).toList(),
        ),
      ],
    );
  }

  CustomStep buildStep(ActivityStep step) {
    final isCompleted = _planterActivity != null &&
        _planterActivity.completedSteps >= step.number;
    final canComplete = _planterActivity != null &&
        _planterActivity.completedSteps == step.number - 1;
    return CustomStep(
      isCompleted: isCompleted,
      icon: CircleAvatar(
        backgroundColor:
            isCompleted ? MainColors.lightGreen : MainColors.lightGrey,
        radius: 24,
        child: Icon(
          step.iconData,
          size: 32,
          color: isCompleted ? MainColors.white : MainColors.black,
        ),
      ),
      title: Text(step.description),
      subtitle: Text('${step.karma} Karma'),
      onTap: canComplete ? () => showCompleteStepDialog(step) : null,
    );
  }

  void showCompleteStepDialog(ActivityStep step) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(Strings.markStepCompleted),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.comment, size: 22),
            hintText: Strings.comment,
            errorText: _error,
            isDense: true,
          ),
        ),
        actions: [
          FlatButton(
            textColor: Colors.red,
            onPressed: () {
              Navigator.pop(context);
              _commentController.clear();
              setState(() => _error = null);
            },
            child: const Text(Strings.cancel),
          ),
          FlatButton(
            textColor: MainColors.lightGreen,
            onPressed: () => submit(step),
            child: const Text(Strings.submit),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 48,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [CircularProgressIndicator()],
        ),
      ),
    );
  }

  Future<void> submit(ActivityStep step) async {
    setState(() => _error = null);
    Navigator.pop(context);
    showLoadingDialog();
    try {
      final result = await context.read<Api>().logPlanterCheckIn(
            context.read<AuthModel>().user.id,
            PlanterCheckIn(
              activityId: widget.activity.id,
              activityTitle: widget.activity.title,
              activityStep: step.number,
              checkinType: CheckInActivityType(
                step.number == 1
                    ? CheckInActivityType.newActivityStarted
                    : CheckInActivityType.activityProgressUpdate,
              ),
              comment: _commentController.text,
              timestamp: DateTime.now().toIso8601String(),
            ),
            context.read<AuthModel>().tokenData.accessToken,
          );
      _commentController.clear();
      setState(() {
        _planterActivity = PlanterActivity.fromCheckin(
          activity: widget.activity,
          checkIn: result,
        );
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
      Navigator.pop(context);
      showCompleteStepDialog(step);
    }
  }
}
