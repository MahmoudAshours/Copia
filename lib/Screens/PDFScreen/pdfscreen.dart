import 'dart:async';

import 'package:copia/Hive/database.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive/hive.dart';

class PDFScreen extends StatefulWidget {
  final PDFDB snapshot;
  final int index;
  final PDFDB lastOpenedSnapshot;
  PDFScreen({this.snapshot, this.index, this.lastOpenedSnapshot});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool isReady = false;
  String errorMessage = '';
  bool s = true;
  var currPage = 0;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
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
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: _circularFab(_controller),
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
              onPageChanged: (s, ss) => setState(() => currPage = s),
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
              onViewCreated: (s) => _controller.complete(s),
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
        ? widget.snapshot.pdfAsset
        : widget.lastOpenedSnapshot.pdfAsset;
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

  _circularFab(controller) {
    return AnimatedCrossFade(
      crossFadeState: _crossFadeState,
      duration: Duration(seconds: 1),
      firstChild: FabCircularMenu(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: Hive.box('name').getAt(widget.index).bookmarked != null
                ? Hive.box('name')
                        .getAt(widget.index)
                        .bookmarked
                        .contains(currPage)
                    ? Colors.yellow
                    : Colors.black
                : Colors.black87,
            onPressed: () {
              Hive.box('name').putAt(
                0,
                PDFDB(
                    insertedDate: widget.snapshot.insertedDate,
                    lastSeenDate: DateTime.now(),
                    pdfAsset: widget.snapshot.pdfAsset,
                    pdfName: widget.snapshot.pdfName,
                    totalHours: widget.snapshot.totalHours,
                    thumb: widget.snapshot.thumb,
                    bookmarked: test(currPage)),
              );
            },
          ),
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

  List<int> test(currentpage) {
    if (widget.snapshot.bookmarked != null) {
      return [
        currentpage,
        ...Hive.box('name')?.getAt(widget.index)?.bookmarked
      ];
    } else {
      return [currentpage];
    }
  }

  void _update() {
    widget.snapshot != null
        ? Hive.box('name').putAt(
            widget.index,
            PDFDB(
                insertedDate: widget.snapshot.insertedDate,
                lastSeenDate: DateTime.now(),
                pdfAsset: widget.snapshot.pdfAsset,
                pdfName: widget.snapshot.pdfName,
                totalHours: widget.snapshot.totalHours,
                thumb: widget.snapshot.thumb,
                bookmarked: widget.snapshot.bookmarked),
          )
        : Hive.box('name').putAt(
            widget.index,
            PDFDB(
                insertedDate: widget.lastOpenedSnapshot.insertedDate,
                lastSeenDate: DateTime.now(),
                pdfAsset: widget.lastOpenedSnapshot.pdfAsset,
                pdfName: widget.lastOpenedSnapshot.pdfName,
                totalHours: widget.lastOpenedSnapshot.totalHours,
                thumb: widget.lastOpenedSnapshot.thumb,
                bookmarked: widget.lastOpenedSnapshot.bookmarked),
          );
  }
}
