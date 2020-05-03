import 'package:copia/Moor/table.dart';
import 'package:flutter/material.dart';
import 'package:majesty/MajestySubtleNav/subtle_bottomnavbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  MajestySubtleBottomNavBar _bottomNavBar() {
    return MajestySubtleBottomNavBar(
      backgroundColor: Colors.black,
      animationCurve: Curves.bounceOut,
      selectorColor: Colors.redAccent,
      captions: ['Home', 'Search', 'Bookmarks'],
      selectedItemColor: Colors.white,
      nonSelectedIconColor: Color(0xff616064),
      captionsTextStyles: TextStyle(color: Colors.white),
      items: <Widget>[
        Icon(Icons.home),
        Icon(Icons.search),
        Icon(Icons.bookmark)
      ],
      onItemPressed: (i) {
        print(i);
      },
    );
  }
}
