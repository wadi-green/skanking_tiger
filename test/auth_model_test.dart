import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:test/test.dart';
import 'package:wadi_green/api/mock/data/mock_planter_data.dart';
import 'package:wadi_green/data/login_response.dart';
import 'package:wadi_green/data/planter.dart';
import 'package:wadi_green/models/auth_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication State', () {
    test('After login, user is marked as logged in', () {
      final authModel = AuthModel(restoreUser: false);
      authModel.login(const LoginResponse(), Planter.fromJson(dummyPlanter));
      expect(authModel.isLoggedIn, true);
    });

    test('After logout, user is marked as logged out', () {
      final authModel = AuthModel(restoreUser: false);
      authModel.login(const LoginResponse(), Planter.fromJson(dummyPlanter));
      expect(authModel.isLoggedIn, true);
      authModel.logout();
      expect(authModel.isLoggedIn, false);
    });
  });
}
