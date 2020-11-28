import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wadi_green/api/api.dart';
import 'package:wadi_green/api/mock/data/mock_planter_data.dart';
import 'package:wadi_green/api/mock/mock_api.dart';
import 'package:wadi_green/data/login_response.dart';
import 'package:wadi_green/data/planter.dart';
import 'package:wadi_green/models/auth_model.dart';
import 'package:wadi_green/screens/landing_screen.dart';
import 'package:wadi_green/utils/strings.dart';
import 'package:wadi_green/widgets/custom_drawer.dart';

void main() {
  AuthModel authModel;

  setUpAll(() {
    authModel = AuthModel(restoreUser: false);
  });

  tearDownAll(() {
    authModel?.dispose();
  });

  testWidgets(
    'Change the drawer items depending on the authentication state',
    (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>(
            create: (_) => MockApi(loadingDuration: const Duration()),
          ),
        ],
        child: const MaterialApp(home: CustomDrawer()),
      ));
      // User is now logged out
      expect(find.text(Strings.login, skipOffstage: false), findsOneWidget);
      expect(find.text(Strings.signUp, skipOffstage: false), findsOneWidget);
      expect(find.text(Strings.logout, skipOffstage: false), findsNothing);

      authModel.login(const LoginResponse(), Planter.fromJson(dummyPlanter));
      await tester.pump();

      // User is now logged in
      expect(find.text(Strings.login, skipOffstage: false), findsNothing);
      expect(find.text(Strings.signUp, skipOffstage: false), findsNothing);
      expect(find.text(Strings.settings, skipOffstage: false), findsOneWidget);
    },
  );

  testWidgets(
    'Mark the active route as enabled in the drawer',
    (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authModel),
          Provider<Api>(
            create: (_) => MockApi(loadingDuration: const Duration()),
          ),
        ],
        child: MaterialApp(
          initialRoute: LandingScreen.route,
          routes: {
            LandingScreen.route: (_) => const LandingScreen(isMain: true),
          },
        ),
      ));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));

      final ListTile homeTile = tester.firstWidget(
        find.widgetWithText(ListTile, Strings.home),
      );
      expect(homeTile.selected, true);
      final ListTile activitiesTile = tester.firstWidget(
        find.widgetWithText(ListTile, Strings.activities),
      );
      expect(activitiesTile.selected, false);
    },
  );
}
