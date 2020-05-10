import 'package:copia/Hive/database.dart';
import 'package:copia/app.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(PDFDBAdapter());
  Hive.openBox('name');
  runApp(MyApp());
}
