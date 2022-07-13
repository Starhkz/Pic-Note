import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pic_note/models/screen_data.dart';
import 'package:pic_note/screens/display.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import 'imports.dart';
import 'shared/styling/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Open the database and store the reference.
  // get the platform
  bool isMobile() {
    Platform platform = const LocalPlatform();
    return platform.isAndroid || platform.isIOS;
  }

  if (isMobile()) {
    await PicDataBase().initDB();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => PicDataBase()),
      ChangeNotifierProvider(create: (_) => ScreenDataNotifier()),
    ], child: const MyApp()));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pic Note',
        darkTheme: customDarkTheme(),
        theme: customLightTheme(),
        themeMode: ThemeMode.system,
        home: const Display());
  }
}
