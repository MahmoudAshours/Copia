import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class BookmarkList extends StatelessWidget {
  final int index;
  final PdfController pdfController;
  BookmarkList({this.index, this.pdfController});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.list), onPressed: () => _bookmarksSheet(context));
  }

  void _bookmarksSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 400,
        decoration: BoxDecoration(
            color: const Color(0xffEEEEED),
            borderRadius: BorderRadius.circular(40)),
        child: Stack(
          children: <Widget>[
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box('name').listenable(),
              builder: (_, Box snap, __) {
                if (snap.getAt(index).bookmarked == null ||
                    snap.getAt(index).bookmarked.isEmpty) {
                  return Center(
                      child: Text('You dont have any favorites yet!'));
                }
                return ListView(
                  children: snap.getAt(index).bookmarked.map<Widget>(
                    (int pageNumber) {
                      return ListTile(
                        title: Text('Page number $pageNumber'),
                        leading: Icon(Icons.favorite_border, color: Colors.red),
                        onTap: () => pdfController
                            .animateToPage(
                              pageNumber,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOutBack,
                            )
                            .then((_) => Navigator.of(context).pop()),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
