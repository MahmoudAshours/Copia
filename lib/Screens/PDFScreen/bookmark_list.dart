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
      builder: (_) => Container(
        height: 400,
        child: ValueListenableBuilder(
          valueListenable: Hive.box('name').listenable(),
          builder: (_, Box snap, __) => ListView(
            children: snap
                .getAt(index)
                .bookmarked
                .map<Widget>(
                  (int e) => ListTile(
                    title: Text('Page number $e'),
                    onTap: () => pdfController
                        .animateToPage(e,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOutBack)
                        .then((_) => Navigator.of(context).pop()),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
