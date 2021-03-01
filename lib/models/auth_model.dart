import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/app_config.dart';
import '../data/login_response.dart';
import '../data/planter.dart';

/// Handles everything related to user authentication, including saving and
/// retrieving the user data on the device
class AuthModel extends ChangeNotifier {
  LoginResponse tokenData;
  Planter user;
  bool get isLoggedIn => user != null;

  AuthModel({bool restoreUser = true}) {
    if (restoreUser) _restoreSavedData();
  }

  void login(LoginResponse authData, Planter planter, {bool persist = false}) {
    user = planter;
    tokenData = authData;
    notifyListeners();
    if (persist) {
      _saveLocalData();
    }
  }

  void logout() {
    user = null;
    notifyListeners();
    _deleteLocalData();
  }

  void updateUser(Planter updatedUser) {
    user = updatedUser;
    notifyListeners();
    _saveLocalData();
  }

  Future<void> _saveLocalData() async {
    const storage = FlutterSecureStorage();
    await storage.write(
      key: LocalKeys.authUser,
      value: jsonEncode(user.toJson()),
    );
    await storage.write(
      key: LocalKeys.tokenData,
      value: jsonEncode(tokenData.toJson()),
    );
  }

  Future<void> _deleteLocalData() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: LocalKeys.authUser);
    await storage.delete(key: LocalKeys.tokenData);
  }

  Future<void> _restoreSavedData() async {
    const storage = FlutterSecureStorage();
    final savedUser = await storage.read(key: LocalKeys.authUser);
    final savedToken = await storage.read(key: LocalKeys.tokenData);
    // Do the restoration only if both the token and the user are saved
    if (savedUser != null && savedToken != null) {
      user = Planter.fromJson(jsonDecode(savedUser) as Map<String, dynamic>);
      tokenData = LoginResponse.fromJson(
        jsonDecode(savedToken) as Map<String, dynamic>,
      );
      notifyListeners();
    }
  }
}
