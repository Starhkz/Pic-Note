import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'imports.dart';
import 'shared/styling/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  await PicDataBase().initDB();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PicDataBase()),
  ], child: const MyApp()));
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
        home: const Home());
  }
}
