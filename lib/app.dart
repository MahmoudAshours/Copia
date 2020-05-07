import 'package:copia/Screens/ControllerScreen/controller_screen.dart';
import 'package:copia/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Providers(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ControllerScreen(),
      ),
    );
  }
}
