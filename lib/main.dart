import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'context.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initialiseContext();

  runApp(const MyApp());
}
