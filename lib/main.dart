import 'package:copia/Moor/table.dart';
import 'package:copia/Screens/HomeScreen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majesty/MajestySubtleNav/subtle_bottomnavbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
        backgroundColor: Color(0xff090708),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffEEEEED),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70),
            ),
          ),
          child: HomeScreen(),
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  MajestySubtleBottomNavBar _bottomNavBar() {
    return MajestySubtleBottomNavBar(
      backgroundColor: Color(0xff090708),
      animationCurve: Curves.bounceOut,
      selectorColor: Colors.redAccent,
      captions: ['Home', 'Search', 'Bookmarks'],
      selectedItemColor: Colors.white,
      nonSelectedIconColor: Color(0xff616064),
      captionsTextStyles: TextStyle(color: Colors.white),
      items: <Widget>[
        Icon(Icons.home, size: 24),
        Icon(Icons.search),
        Icon(Icons.bookmark)
      ],
      onItemPressed: (i) {
        print(i);
      },
    );
  }
}
