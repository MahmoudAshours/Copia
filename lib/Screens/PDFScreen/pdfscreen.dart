import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';

class PDFScreen extends StatefulWidget {
  final PDFDB snapshot;
  final int index;
  PDFScreen({this.snapshot, this.index});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int index;
  PdfController _pdfController;
  int currentPage = 1;
  Axis direction = Axis.horizontal;
  @override
  void initState() {
    _pdfController =
        PdfController(document: PdfDocument.openFile(widget.snapshot.pdfAsset));
    setState(() => index = widget.index);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final _pdf = PDFDB(
      bookmarked: Hive.box('name').getAt(index).bookmarked,
      insertedDate: Hive.box('name').getAt(index).insertedDate,
      lastSeenDate: Hive.box('name').getAt(index).lastSeenDate,
      lastVisitedPage: _pdfController.page,
      pdfAsset: Hive.box('name').getAt(index).pdfAsset,
      pdfName: Hive.box('name').getAt(index).pdfName,
      thumb: Hive.box('name').getAt(index).thumb,
      totalHours: Hive.box('name').getAt(index).totalHours,
    );
    Hive.box('name')
        .putAt(index, _pdf)
        .then((value) => _pdfController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<ProviderDB>(context);
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: _circularFab(_dbProvider, index),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PdfView(
          controller: _pdfController,
          onDocumentLoaded: (PdfDocument document) {
            _pdfController.jumpToPage(10);
          },
          documentLoader: Center(child: CircularProgressIndicator()),
          pageLoader: Center(child: CircularProgressIndicator()),
          onDocumentError: (err) {
            print("error is : $err");
          },
          pageSnapping: true,
          scrollDirection: direction,
          physics: BouncingScrollPhysics(),
          onPageChanged: (int currPage) {
            print("current : $currPage");
            setState(() => currentPage = currPage);
          },
        ),
      ),
    );
  }

  FabCircularMenu _circularFab(ProviderDB _bloc, int index) {
    return FabCircularMenu(
      children: <Widget>[
        ValueListenableBuilder(
          valueListenable: Hive.box('name').listenable(),
          builder: (_, Box snapshot, Widget child) {
            return IconButton(
              icon: Icon(Icons.favorite),
              color: Hive.box('name').getAt(index).bookmarked != null
                  ? Hive.box('name')
                          .getAt(index)
                          .bookmarked
                          .contains(currentPage)
                      ? Colors.red
                      : Colors.white
                  : Colors.white,
              onPressed: () {
                _bloc.addBookmark(
                  currPage: currentPage,
                  index: index,
                  snapshot: Hive.box('name').getAt(index),
                );
              },
            );
          },
        ),
        IconButton(icon: Icon(Icons.list), onPressed: () => _bookmarksSheet()),
        IconButton(
            icon: Icon(Icons.border_horizontal),
            onPressed: () {
              setState(() {
                if (direction == Axis.horizontal) {
                  direction = Axis.vertical;
                } else {
                  direction = Axis.horizontal;
                }
              });
            }),
      ],
    );
  }

  void _bookmarksSheet() {
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
                    onTap: () => _pdfController
                        .animateToPage(e,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOutBack)
                        .then(
                          (value) => Navigator.of(context).pop(),
                        ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _update() {
    final _bloc = Provider.of<ProviderDB>(context);
    _bloc.updateLastSeen(widget.snapshot, widget.index);
  }
}
