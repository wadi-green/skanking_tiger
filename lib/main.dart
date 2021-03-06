import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'api/api.dart';
import 'api/http/http_api.dart';
import 'core/hive_boxes.dart';
import 'models/auth_model.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox(ActivityLikesBox.key);

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
