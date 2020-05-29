import 'package:copia/Screens/HomeScreen/Widgets/book_cards.dart';
import 'package:copia/Screens/HomeScreen/Widgets/last_opened.dart';
import 'package:copia/Screens/HomeScreen/Widgets/top_bar.dart';
import 'package:copia/Screens/HomeScreen/Widgets/view_cards.dart';
import 'package:copia/Screens/StatsScreen/stats_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        runSpacing: 2,
        direction: Axis.horizontal,
        children: <Widget>[
          TopBar(),
          ViewCards(),
          Divider(),
          BookCards(),
          LastOpened(),
          Center(
            child: RaisedButton(
              child: Text('Statistics'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StatsScreen(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
