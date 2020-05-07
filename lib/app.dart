import 'package:copia/Screens/ControllerScreen/controller_screen.dart';
import 'package:copia/providers.dart';
import 'package:flutter/cupertino.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Providers(
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: ControllerScreen(),
      ),
    );
  }
}
