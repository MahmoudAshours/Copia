import 'dart:convert';
import 'dart:io';

import 'package:copia/Moor/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFScreen extends StatefulWidget {
  final AsyncSnapshot<List<PDFSData>> snapshot;
  final int index;
  PDFScreen({@required this.snapshot, @required this.index});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool isLoaded = false;
  var assetPDFPath = '';
  @override
  void initState() {
    getFileFromAsset().then(
      (value) => setState(
        () {
          assetPDFPath = value;
          print(value);
          isLoaded = true;
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: 400,
              height: 400,
              child: PDFView(
                filePath: assetPDFPath,
                enableSwipe: true,
                swipeHorizontal: true,
                onError: (err) {
                  print("error is : $err");
                },
                pageSnap: true,
                pageFling: true,
                fitEachPage: true,
                onViewCreated: (s) {
                  print('Hello');
                },
                onRender: (_pages) {
                  setState(() {
                    // pages = _pages;
                    // isReady = true;
                  });
                },
              ),
            ),
    );
  }

  Future<String> getFileFromAsset() async {
    try {
      var bytes = base64Decode(
          widget.snapshot.data[widget.index].pdfAsset.replaceAll('\n', ''));
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      return file.path;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }
}
