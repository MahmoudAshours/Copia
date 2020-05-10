import 'package:copia/Screens/HomeScreen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majesty/MajestySubtleNav/subtle_bottomnavbar.dart';

class ControllerScreen extends StatelessWidget {
  final _items = List<Widget>.unmodifiable([
    Icon(Icons.home, size: 24),
    Icon(Icons.search),
    Icon(Icons.bookmark),
  ]);
  final _captions = List<String>.unmodifiable(['Home', 'Search', 'Bookmarks']);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090708),
      body: SingleChildScrollView(
        child: Container(
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
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  MajestySubtleBottomNavBar _bottomNavBar(BuildContext context) {
    return MajestySubtleBottomNavBar(
        backgroundColor: const Color(0xff090708),
        animationCurve: Curves.easeInOutBack,
        selectorColor: Colors.redAccent,
        captions: _captions,
        selectedItemColor: Colors.white,
        nonSelectedIconColor: const Color(0xff616064),
        captionsTextStyles: TextStyle(color: Colors.white),
        items: _items,
        onItemPressed: (i) => print(i));
  }
}
