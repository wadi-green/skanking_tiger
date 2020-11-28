import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/api/api.dart';
import 'package:wadi_green/api/mock/data/mock_planter_data.dart';
import 'package:wadi_green/data/login_response.dart';
import 'package:wadi_green/data/planter.dart';
import 'package:wadi_green/models/auth_model.dart';
import 'package:wadi_green/screens/member_screen.dart';
import 'package:wadi_green/utils/strings.dart';

class TestApi extends Mock implements Api {}

void main() {
  AuthModel authModel;
  final api = TestApi();
  final currentUser = Planter.fromJson(dummyPlanter);

  setUpAll(() {
    authModel = AuthModel(restoreUser: false);
    when(api.fetchPlanterFriends(any)).thenAnswer((_) async => []);
    when(api.fetchPlanterActivities(any)).thenAnswer((_) async => []);
  });
  tearDownAll(() {
    authModel?.dispose();
  });

  testWidgets('Hide all buttons for guest users', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authModel),
        Provider<Api>(create: (_) => api),
      ],
      child: MaterialApp(
        home: MemberScreen(fetchMemberCallback: () async => currentUser),
      ),
    ));
    await tester.pump();
    expect(find.byType(ButtonBar), findsNothing);
  });

  testWidgets('Hide the message button on the current user profile',
      (WidgetTester tester) async {
    authModel.login(const LoginResponse(), currentUser);
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authModel),
        Provider<Api>(create: (_) => api),
      ],
      child: MaterialApp(
        home: MemberScreen(fetchMemberCallback: () async => currentUser),
      ),
    ));
    await tester.pump();
    expect(
      find.widgetWithText(ElevatedButton, Strings.message),
      findsNothing,
    );
  });

  testWidgets('Show the message button for other users',
      (WidgetTester tester) async {
    authModel.login(const LoginResponse(), currentUser);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>(create: (_) => api),
        ],
        child: MaterialApp(
          home: MemberScreen(
            fetchMemberCallback: () async => currentUser.copyWith(
              id: 'An SQL query goes into a bar, walks up to two tables and asks: “Can I join you?”',
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      find.widgetWithText(ElevatedButton, Strings.message),
      findsOneWidget,
    );
  });
}
