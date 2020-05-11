import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/pdfscreen_bloc.dart';
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
  PdfController path;

  @override
  void initState() {
    path = PdfController(
      document: PdfDocument.openFile(widget.snapshot.pdfAsset),
    );

    setState(() {
      index = widget.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    print('here');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<ProviderDB>(context);
    final _pdfProvider = Provider.of<PDFScreenBloc>(context);
    print(path);
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: _circularFab(_dbProvider, _pdfProvider, index),
      body: GestureDetector(
        child: PdfView(
          controller: path,
          onPageChanged: (int currPage) => _pdfProvider.currentPage = currPage,
        ),
      ),
    );
  }

  FabCircularMenu _circularFab(
      ProviderDB _bloc, PDFScreenBloc _pdfBloc, int index) {
    return FabCircularMenu(
      children: <Widget>[
        ValueListenableBuilder(
          valueListenable: Hive.box('name').listenable(),
          builder: (_, Box snapshot, Widget child) {
            final _pdf = snapshot.getAt(0);
            return IconButton(
              icon: Icon(Icons.favorite),
              color: _colorDetector(_pdf, _pdfBloc),
              onPressed: () {
                setState(() {
                  _bloc.addBookmark(
                    currPage: _pdfBloc.currpage,
                    index: index,
                    snapshot: widget.snapshot,
                  );
                });
              },
            );
          },
        ),
        IconButton(icon: Icon(Icons.list), onPressed: () => _bookmarksSheet()),
      ],
    );
  }

  _colorDetector(_pdf, _pdfBloc) {
    return _pdf.bookmarked != null
        ? _pdf.bookmarked.contains(_pdfBloc.currpage)
            ? Colors.yellow
            : Colors.white
        : Colors.black;
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
                .getAt(widget.index)
                .bookmarked
                .map<Widget>((e) => ListTile(title: Text('$e')))
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
