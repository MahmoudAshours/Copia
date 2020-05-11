import 'package:copia/Hive/database.dart';
import 'package:copia/Screens/ControllerScreen/controller_screen.dart';
import 'package:copia/providers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/IntroScreen/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(PDFDBAdapter());
  await Hive.openBox('name');
  runApp(
    Providers(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: await checkIntro() ? IntroScreen() : ControllerScreen(),
      ),
    ),
  );
}

/// Check if it's the user first time in the app.
Future<bool> checkIntro() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('intro') ?? true;
}
