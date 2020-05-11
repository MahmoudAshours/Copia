import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  @override
  void initState() {
    setState(() {
      index = widget.index;
    });
    super.initState();
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

    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: _circularFab(_dbProvider, _pdfProvider, index),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            child: PDFView(
              filePath: widget.snapshot.pdfAsset,
              enableSwipe: true,
              gestureRecognizers: {
                Factory(() => LongPressGestureRecognizer(
                      duration: Duration(milliseconds: 100),
                    ))
              },
              fitPolicy: FitPolicy.BOTH,
              onPageError: (s, d) => print(s),
              defaultPage: 0,
              onPageChanged: (int current, int total) =>
                  _pdfProvider.currentPage = current,
              onError: (error) => _pdfProvider.error = error.toString(),
              pageFling: true,
              fitEachPage: true,
              autoSpacing: true,
              onRender: (_) => _pdfProvider.ready = true,
            ),
          ),
          _pdfProvider.getError.isEmpty
              ? !_pdfProvider.isReady
                  ? Center(child: CircularProgressIndicator())
                  : Container()
              : Center(child: Text(_pdfProvider.getError)),
        ],
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
              onPressed: () => _bloc.addBookmark(
                currPage: _pdfBloc.currpage,
                index: widget.index,
                snapshot: widget.snapshot,
              ),
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
        : Colors.white;
  }

  void _bookmarksSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        width: 100,
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
