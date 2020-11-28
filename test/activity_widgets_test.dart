import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/api/api.dart';
import 'package:wadi_green/api/mock/data/mock_activity_data.dart';
import 'package:wadi_green/api/mock/mock_api.dart';
import 'package:wadi_green/core/routes.dart';
import 'package:wadi_green/data/activity/activity.dart';
import 'package:wadi_green/models/auth_model.dart';
import 'package:wadi_green/screens/activity_details_screen.dart';
import 'package:wadi_green/screens/log_in_screen.dart';
import 'package:wadi_green/widgets/activities/activity_steps_widget.dart';

void main() {
  AuthModel authModel;
  final Api api = MockApi(loadingDuration: const Duration());

  setUpAll(() {
    authModel = AuthModel(restoreUser: false);
  });

  tearDownAll(() {
    authModel?.dispose();
  });

  group('Stepper Widget', () {
    testWidgets(
      'Stepper widget shows all the steps to complete in an activity',
      (WidgetTester tester) async {
        final activity = Activity.fromJson(dummyActivity);
        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authModel),
            Provider<Api>.value(value: api),
          ],
          child: MaterialApp(home: ActivityStepsWidget(activity: activity)),
        ));

        expect(find.byType(CircleAvatar), findsNWidgets(activity.steps.length));
      },
    );
  });

  group('Action buttons on an activity redirect the guest user to login', () {
    testWidgets('Add activity button', (WidgetTester tester) async {
      final activity = Activity.fromJson(dummyActivity);
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>.value(value: api),
        ],
        child: MaterialApp(
          onGenerateRoute: onGenerateRoute,
          home: ActivityDetailsScreen(
            fetchActivityCallback: () async => activity,
          ),
        ),
      ));
      await tester.pump();
      await tester.tap(find.byTooltip('Add to my activities'));
      await tester.pumpAndSettle();
      expect(find.byType(LogInScreen), findsOneWidget);
    });
    testWidgets('Share button', (WidgetTester tester) async {
      final activity = Activity.fromJson(dummyActivity);
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>.value(value: api),
        ],
        child: MaterialApp(
          onGenerateRoute: onGenerateRoute,
          home: ActivityDetailsScreen(
            fetchActivityCallback: () async => activity,
          ),
        ),
      ));
      await tester.pump();
      await tester.tap(find.byTooltip('Share'));
      await tester.pumpAndSettle();
      expect(find.byType(LogInScreen), findsOneWidget);
    });
    testWidgets('Like button', (WidgetTester tester) async {
      final activity = Activity.fromJson(dummyActivity);
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>.value(value: api),
        ],
        child: MaterialApp(
          onGenerateRoute: onGenerateRoute,
          home: ActivityDetailsScreen(
            fetchActivityCallback: () async => activity,
          ),
        ),
      ));
      await tester.pump();
      await tester.tap(find.byTooltip('Like'));
      await tester.pumpAndSettle();
      expect(find.byType(LogInScreen), findsOneWidget);
    });
  });
}
