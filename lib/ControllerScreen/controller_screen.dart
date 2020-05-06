import 'package:copia/Screens/HomeScreen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majesty/MajestySwipeNav/swipe_nav.dart';
import 'package:majesty/MajestySwipeNav/swipe_scaffold.dart';

class ControllerScreen extends StatelessWidget {
  final _items = List<Widget>.unmodifiable([
    Icon(Icons.home, size: 24),
    Icon(Icons.search),
    Icon(Icons.bookmark),
  ]);
  final _captions = List<String>.unmodifiable(['Home', 'Search', 'Bookmarks']);
  Widget build(BuildContext context) {
    return MajestySwipeScaffold(
      child: Scaffold(
        backgroundColor: const Color(0xff090708),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: const Color(0xffEEEEED),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70),
            ),
          ),
          child: HomeScreen(),
        ),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  MajestySwipeNavigationBar _bottomNavBar(BuildContext context) {
    return MajestySwipeNavigationBar(
        backgroundColor: const Color(0xff090708),
        animationCurve: Curves.easeInOutBack,
        selectorColor: Colors.redAccent,
        captions: _captions,
        selectedItemColor: Colors.white,
        swipedHeight: 200,
        nonSelectedIconColor: const Color(0xff616064),
        captionsTextStyle: TextStyle(color: Colors.white),
        items: _items,
        onItemPressed: (i) => print(i));
  }
}
