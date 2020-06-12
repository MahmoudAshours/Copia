import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class BookmarkPdf extends StatelessWidget {
  final int index;
  final int currentPage;
  BookmarkPdf({@required this.index, @required this.currentPage});
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<ProviderDB>(context);
    final hive = Hive.box('pdfDB');
    return ValueListenableBuilder(
      valueListenable: hive.listenable(),
      builder: (_, Box snapshot, Widget child) {
        final PDFDB _pdf = hive.getAt(index);
        return GestureDetector(
          onTap: () => bookmark(_bloc, _pdf),
          child: NeumorphicIcon(
            Icons.favorite,
            style: NeumorphicStyle(
              color: _bookmarkColorChecker(_pdf),
              depth: 20,
              shadowDarkColor: Colors.black12
            ),
          ),
        );
      },
    );
  }

  void bookmark(ProviderDB _bloc, PDFDB _pdf) {
    if (_pdf.bookmarked != null) {
      if (_pdf.bookmarked.contains(currentPage)) {
        _bloc.addBookmark(
          false,
          currPage: currentPage,
          index: index,
          snapshot: _pdf,
        );
      } else {
        _bloc.addBookmark(
          true,
          currPage: currentPage,
          index: index,
          snapshot: _pdf,
        );
      }
    } else {
      _bloc.addBookmark(
        true,
        currPage: currentPage,
        index: index,
        snapshot: _pdf,
      );
    }
  }

  Color _bookmarkColorChecker(PDFDB _pdf) {
    if (_pdf.bookmarked != null) {
      if (_pdf.bookmarked.contains(currentPage)) {
        return Colors.red;
      } else {
        return Colors.white;
      }
    } else {
      return Colors.white;
    }
  }
}
