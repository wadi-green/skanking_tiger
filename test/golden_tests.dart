import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/api/api.dart';
import 'package:wadi_green/api/mock/data/mock_activity_data.dart';
import 'package:wadi_green/api/mock/data/mock_planter_data.dart';
import 'package:wadi_green/custom_painters/easiness_indicator_painter.dart';
import 'package:wadi_green/data/activity/activity.dart';
import 'package:wadi_green/data/activity/planter_activity.dart';
import 'package:wadi_green/data/login_response.dart';
import 'package:wadi_green/data/planter.dart';
import 'package:wadi_green/models/auth_model.dart';
import 'package:wadi_green/widgets/activities/activity_steps_widget.dart';

class TestApi extends Mock implements Api {}

void main() {
  group('Easiness Widget', () {
    testWidgets('Easiness Widget fills the correct number of bars',
        (WidgetTester tester) async {
      // Level 0
      await tester.pumpWidget(createEasinessLevelIndicator(0));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/0.png'),
      );

      // Level 1
      await tester.pumpWidget(createEasinessLevelIndicator(1));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/1.png'),
      );

      // Level 2
      await tester.pumpWidget(createEasinessLevelIndicator(2));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/2.png'),
      );

      // Level 3
      await tester.pumpWidget(createEasinessLevelIndicator(3));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/3.png'),
      );

      // Level 4
      await tester.pumpWidget(createEasinessLevelIndicator(4));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/4.png'),
      );

      // Level 5
      await tester.pumpWidget(createEasinessLevelIndicator(5));
      await expectLater(
        find.byType(Center),
        matchesGoldenFile('golden/easiness/5.png'),
      );
    });
  });

  group('Stepper Widget', () {
    AuthModel authModel;
    final api = TestApi();

    setUpAll(() {
      authModel = AuthModel(restoreUser: false);
    });

    tearDownAll(() {
      authModel?.dispose();
    });
    testWidgets(
      'Stepper widget with guest user',
      (WidgetTester tester) async {
        final activity = Activity.fromJson(dummyActivity);
        await tester.pumpWidget(
          createActivityStepper(authModel, api, activity),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(ActivityStepsWidget),
          matchesGoldenFile('golden/stepper/guest-user.png'),
        );
      },
    );
    testWidgets(
      'Stepper widget with authenticated user and no steps completed',
      (WidgetTester tester) async {
        final activity = Activity.fromJson(dummyActivity);
        final user = Planter.fromJson(dummyPlanter);
        when(api.fetchPlanterActivity(user.id, activity.id)).thenAnswer(
          (_) async => PlanterActivity.fromNewActivity(activity),
        );
        authModel.login(const LoginResponse(), user);
        await tester.pumpWidget(
          createActivityStepper(authModel, api, activity),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(ActivityStepsWidget),
          matchesGoldenFile('golden/stepper/none-completed.png'),
        );
      },
    );
    testWidgets(
      'Stepper widget with authenticated user and one step completed',
      (WidgetTester tester) async {
        final activity = Activity.fromJson(dummyActivity);
        final user = Planter.fromJson(dummyPlanter);
        when(api.fetchPlanterActivity(user.id, activity.id)).thenAnswer(
          (_) async => PlanterActivity(
            activityId: activity.id,
            activityTitle: activity.title,
            activityImage: activity.image,
            shortDescription: activity.shortDescription,
            completedSteps: 1,
            isComplete: false,
            activityEase: activity.ease,
            activityLikes: activity.likes,
          ),
        );
        authModel.login(const LoginResponse(), user);
        await tester.pumpWidget(
          createActivityStepper(authModel, api, activity),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(ActivityStepsWidget),
          matchesGoldenFile('golden/stepper/one-completed.png'),
        );
      },
    );
    testWidgets(
      'Stepper widget with authenticated user and all steps completed',
      (WidgetTester tester) async {
        final activity = Activity.fromJson(dummyActivity);
        final user = Planter.fromJson(dummyPlanter);
        when(api.fetchPlanterActivity(user.id, activity.id)).thenAnswer(
          (_) async => PlanterActivity(
            activityId: activity.id,
            activityTitle: activity.title,
            activityImage: activity.image,
            shortDescription: activity.shortDescription,
            completedSteps: activity.totalSteps,
            isComplete: false,
            activityEase: activity.ease,
            activityLikes: activity.likes,
          ),
        );
        authModel.login(const LoginResponse(), user);
        await tester.pumpWidget(
          createActivityStepper(authModel, api, activity),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(ActivityStepsWidget),
          matchesGoldenFile('golden/stepper/all-completed.png'),
        );
      },
    );
  });
}

Widget createEasinessLevelIndicator(int level) {
  return Center(
    child: RepaintBoundary(
      child: SizedBox(
        width: 500,
        height: 500,
        child: CustomPaint(
          painter: EasinessIndicatorPainter(value: level, barCount: 5),
        ),
      ),
    ),
  );
}

Widget createActivityStepper(AuthModel authModel, Api api, Activity activity) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: authModel),
      Provider<Api>.value(value: api),
    ],
    child: MaterialApp(
      home: Center(
        child: SizedBox(
          height: 500,
          width: 500,
          child: ActivityStepsWidget(activity: activity),
        ),
      ),
    ),
  );
}
