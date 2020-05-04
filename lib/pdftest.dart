import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PDFViews extends StatefulWidget {
  @override
  _PDFViewsState createState() => _PDFViewsState();
}

class _PDFViewsState extends State<PDFViews> {
  var assetPDFPath = '';
  var bits;
  bool isLoaded = false;
  @override
  void initState() {
    getFileFromAsset("assets/maths.pdf").then((f) {
      setState(() {
        assetPDFPath = f.path;
        isLoaded = true;
        print(assetPDFPath);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => {
                    print('hello'),
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: QrImage(
                            data: '${bits ?? 123}',
                            errorStateBuilder: (err, s) {
                              return Container(
                                child: Text('$s'),
                              );
                            },
                            version: 15,
                            size: 200.0,
                          ),
                        ),
                      ),
                    )
                  },
                ),
                Container(
                  width: 100,
                  height: 100,
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
                      defaultPage: 2,
                      onRender: (_pages) {
                        setState(() {
                          // pages = _pages;
                          // isReady = true;
                        });
                      }),
                ),
              ],
            ),
          );
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/maths.pdf");
      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }
}
