import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/api/api.dart';
import 'package:wadi_green/api/mock/data/mock_planter_data.dart';
import 'package:wadi_green/data/checkin_activity_type.dart';
import 'package:wadi_green/data/login_response.dart';
import 'package:wadi_green/data/planter.dart';
import 'package:wadi_green/data/planter_checkin.dart';
import 'package:wadi_green/models/auth_model.dart';
import 'package:wadi_green/widgets/dashboard/planter_calendar.dart';

class TestApi extends Mock implements Api {}

void main() {
  AuthModel authModel;
  final Api api = TestApi();
  final today = DateTime.now();

  setUpAll(() {
    authModel = AuthModel(restoreUser: false);
    authModel.login(const LoginResponse(), Planter.fromJson(dummyPlanter));
    when(
      api.fetchPlanterCheckIns(authModel.user.id, today.month, today.year),
    ).thenAnswer(
      (_) async => [
        PlanterCheckIn(
          activityId: 'abc',
          activityTitle: 'EVENT TITLE',
          activityStep: 1,
          checkinType: const CheckInActivityType(
            CheckInActivityType.activityProgressUpdate,
          ),
          comment: '',
          timestamp: DateTime(today.year, today.month, 7).toIso8601String(),
        ),
        PlanterCheckIn(
          activityId: 'def',
          activityTitle: 'EVENT TITLE',
          activityStep: 1,
          checkinType: const CheckInActivityType(
            CheckInActivityType.activityProgressUpdate,
          ),
          comment: '',
          timestamp: DateTime(today.year, today.month, 16).toIso8601String(),
        )
      ],
    );
  });

  tearDownAll(() {
    authModel?.dispose();
  });

  testWidgets(
    'The calendar marks the current month events',
    (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>.value(value: api),
        ],
        child: MaterialApp(
          home: SingleChildScrollView(
            child: PlanterCalendar(
              planter: authModel.user,
              title: 'Calendar',
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final lastDayOfMonth = DateTime(today.year, today.month + 1, 0).day;
      for (var i = 1; i <= lastDayOfMonth; i++) {
        expect(
          find.byKey(ValueKey('events_${today.month}_$i')),
          i == 7 || i == 16 // days of the events provided
              ? findsOneWidget
              : findsNothing,
        );
      }
    },
  );

  testWidgets(
    'The calendar displays only the selected day events under it',
    (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>.value(value: api),
        ],
        child: MaterialApp(
          home: SingleChildScrollView(
            child: PlanterCalendar(
              planter: authModel.user,
              title: 'Calendar',
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('12'));
      await tester.pump();
      expect(find.text('EVENT TITLE'), findsNothing);

      await tester.tap(find.text('16'));
      await tester.pump();
      expect(find.text('EVENT TITLE'), findsOneWidget);
    },
  );
}
