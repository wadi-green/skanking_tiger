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

void main() {
  AuthModel authModel;
  setUpAll(() {
    authModel = AuthModel(restoreUser: false);
  });
  tearDownAll(() {
    authModel?.dispose();
  });

  testWidgets('Show the call to action button only when logged out',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authModel),
        Provider<Api>(
          create: (_) => MockApi(loadingDuration: const Duration()),
        ),
      ],
      child: const MaterialApp(home: LandingScreen()),
    ));
    // wait for the mock requests to complete
    await tester.pump(const Duration(milliseconds: 1));
    expect(
      find.widgetWithText(
        ElevatedButton,
        Strings.becomeAPlanter,
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    authModel.login(const LoginResponse(), Planter.fromJson(dummyPlanter));
    await tester.pump();
    expect(
      find.widgetWithText(
        ElevatedButton,
        Strings.becomeAPlanter,
        skipOffstage: false,
      ),
      findsNothing,
    );
  });
}
