import 'package:copia/Moor/table.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

class PDFScreen extends StatefulWidget {
  final AsyncSnapshot<List<PDFSData>> snapshot;
  final int index;
  final AsyncSnapshot<PDFSData> lastOpenedSnapshot;
  PDFScreen({this.snapshot, this.index, this.lastOpenedSnapshot});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool isReady = false;
  String errorMessage = '';
  bool s = true;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  PDFViewController _controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _filePath();
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: _circularFab(),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onLongPress: () => _press(),
            child: PDFView(
              filePath: _filePath(),
              enableSwipe: true,
              gestureRecognizers: {
                Factory(() => LongPressGestureRecognizer(
                    duration: Duration(milliseconds: 100)))
              },
              fitPolicy: FitPolicy.BOTH,
              onPageError: (s, d) => print(s),
              defaultPage: 0,
              swipeHorizontal: s,
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              pageFling: true,
              fitEachPage: true,
              autoSpacing: true,
              onViewCreated: (s) => _controller = s,
              onRender: (_pages) {
                setState(() {
                  isReady = true;
                });
              },
            ),
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(child: CircularProgressIndicator())
                  : Container()
              : Center(child: Text(errorMessage)),
        ],
      ),
    );
  }

  String _filePath() {
    final path = widget.snapshot != null
        ? widget.snapshot.data[widget.index].pdfAsset
        : widget.lastOpenedSnapshot.data.pdfAsset;
    return path;
  }

  _press() {
    if (s) {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
        s = false;
      });
    } else {
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
        s = false;
      });
    }
  }

  _circularFab() {
    return AnimatedCrossFade(
      crossFadeState: _crossFadeState,
      duration: Duration(seconds: 1),
      firstChild: FabCircularMenu(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                print('Home');
              }),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              print('Favorite');
            },
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
      ),
      secondChild: FlutterLogo(),
    );
  }

  void _update() {
    final singlePDF = widget.snapshot != null
        ? widget.snapshot.data[widget.index]
        : widget.lastOpenedSnapshot.data;
    final _dbProvider = Provider.of<AppDatabase>(context);
    _dbProvider.updatePDF(singlePDF.copyWith(lastSeenDate: DateTime.now()));
  }
}
