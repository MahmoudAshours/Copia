import 'package:copia/Moor/table.dart';
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

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: _filePath(),
            enableSwipe: true,
            fitPolicy: FitPolicy.BOTH,
            swipeHorizontal: true,
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            pageFling: true,
            fitEachPage: true,
            autoSpacing: true,
            onViewCreated: (s) {
              print('Hello');
            },
            onRender: (_pages) {
              setState(() {
                isReady = true;
              });
            },
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

  String _filePath() => widget.snapshot != null
      ? widget.snapshot.data[widget.index].pdfAsset
      : widget.lastOpenedSnapshot.data.pdfAsset;

  void _update() {
    final singlePDF = widget.snapshot != null
        ? widget.snapshot.data[widget.index]
        : widget.lastOpenedSnapshot.data;
    final _dbProvider = Provider.of<AppDatabase>(context);
    _dbProvider.updatePDF(singlePDF.copyWith(lastSeenDate: DateTime.now()));
  }
}
