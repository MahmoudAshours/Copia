import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  int currentPage;
  double height = 100;
  bool hideFab = false;
  Axis direction = Axis.horizontal;
  ScrollController _controller;
  @override
  void initState() {
    initPage();

    _controller = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final _lastPdf = Hive.box('name').getAt(index);
    final _pdf = PDFDB(
      bookmarked: _lastPdf.bookmarked,
      insertedDate: _lastPdf.insertedDate,
      lastSeenDate: _lastPdf.lastSeenDate,
      lastVisitedPage: currentPage,
      pdfAsset: _lastPdf.pdfAsset,
      pdfName: _lastPdf.pdfName,
      thumb: _lastPdf.thumb,
      totalHours: _lastPdf.totalHours,
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
      body: GestureDetector(
        onTap: () => _hideFloatingActionBar(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PdfView(
            controller: _pdfController,
            documentLoader: Center(child: CircularProgressIndicator()),
            pageLoader: Center(child: CircularProgressIndicator()),
            onDocumentError: (err) => Navigator.of(context).pop(),
            renderer: (PdfPage page) => page.render(
              width: page.width * 2,
              height: page.height * 2,
              format: PdfPageFormat.JPEG,
              backgroundColor: '#FFFFFF',
            ),
            errorBuilder: (e) {
              return Container(
                child: Text('error'),
                width: 200,
                height: 200,
              );
            },
            pageSnapping: true,
            scrollDirection: direction,
            physics: BouncingScrollPhysics(),
            onPageChanged: (int currPage) =>
                setState(() => currentPage = currPage),
          ),
        ),
      ),
    );
  }

  _hideFloatingActionBar() {
    if (hideFab) {
      setState(() {
        hideFab = false;
      });
    } else {
      setState(() {
        hideFab = true;
      });
    }
  }

  AnimatedOpacity _circularFab(ProviderDB _bloc, int index) {
    return AnimatedOpacity(
      opacity: hideFab ? 0.0 : 1.0,
      duration: Duration(milliseconds: 400),
      child: FabCircularMenu(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: Hive.box('name').listenable(),
            builder: (_, Box snapshot, Widget child) {
              final PDFDB _pdf = Hive.box('name').getAt(index);
              return IconButton(
                  icon: Icon(Icons.favorite),
                  color: _bookmarkColorChecker(_pdf),
                  onPressed: () => bookmark(_bloc, _pdf));
            },
          ),
          IconButton(
              icon: Icon(Icons.list), onPressed: () => _bookmarksSheet()),
          IconButton(
            icon: Icon(Icons.border_horizontal),
            onPressed: () {
              setState(
                () {
                  if (direction == Axis.horizontal) {
                    direction = Axis.vertical;
                  } else {
                    direction = Axis.horizontal;
                  }
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.note),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (_, StateSetter setState) {
                    _controller.addListener(
                      () {
                        if (_controller.position.userScrollDirection ==
                            ScrollDirection.reverse) {
                          setState(() =>
                              height = MediaQuery.of(context).size.height);
                        }
                      },
                    );
                    return AnimatedContainer(
                      height: height,
                      duration: Duration(seconds: 1),
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          children: <Widget>[
                            TextField(),
                            FloatingActionButton(onPressed: () {})
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
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
                        .then((_) => Navigator.of(context).pop()),
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

  void initPage() {
    setState(() => index = widget.index);
    _pdfController = PdfController(
        document: PdfDocument.openFile(widget.snapshot.pdfAsset),
        initialPage: Hive.box('name').getAt(index).lastVisitedPage ?? 1,
        viewportFraction: 2);
    setState(() => currentPage = _pdfController.initialPage);
  }
}
