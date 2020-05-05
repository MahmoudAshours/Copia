import 'package:copia/Moor/table.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:copia/Screens/HomeScreen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majesty/MajestySwipeNav/swipe_nav.dart';
import 'package:majesty/MajestySwipeNav/swipe_scaffold.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadPdfBloc()),
        Provider(create: (_) => AppDatabase())
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
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
      child: MajestySwipeScaffold(
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
      ),
    );
  }

  MajestySwipeNavigationBar _bottomNavBar() {
    return MajestySwipeNavigationBar(
      backgroundColor: Color(0xff090708),
      animationCurve: Curves.easeInOutBack,
      selectorColor: Colors.redAccent,
      captions: ['Home', 'Search', 'Bookmarks'],
      selectedItemColor: Colors.white,
      swipedHeight: MediaQuery.of(context).size.height/5,
      nonSelectedIconColor: Color(0xff616064),
      captionsTextStyle: TextStyle(color: Colors.white),
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
