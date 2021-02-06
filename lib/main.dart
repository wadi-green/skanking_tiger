import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'api/api.dart';
import 'api/http/http_api.dart';
import 'models/auth_model.dart';
import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Use this provider to inject the desired API interface
  /// In order to use the real API, replace [MockApi] with [HttpApi]
  final apiProvider = Provider<Api>(create: (_) => HttpApi());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
          create: (_) => AuthModel(),
          lazy: false,
        ),
        apiProvider,
      ],
      child: MyApp(),
    ),
  );
}
