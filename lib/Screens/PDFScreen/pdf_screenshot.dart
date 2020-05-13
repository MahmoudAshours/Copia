import 'dart:io';
import 'dart:ui';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PdfScreenshot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pdfProvider = Provider.of<PDFScreenBloc>(context);
    return IconButton(
      icon: Icon(Icons.camera),
      onPressed: () => _takeScreenshot(context, _pdfProvider),
    );
  }

  Future<void> _takeScreenshot(
      BuildContext context, PDFScreenBloc pdfProvider) async {
    RenderRepaintBoundary boundary =
        pdfProvider.scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    ImageGallerySaver.saveImage(pngBytes);
    final directory = await getApplicationDocumentsDirectory();
    File imgFile = new File('$directory/pdfScreenshot.png');
    imgFile.writeAsBytes(pngBytes).then(
          (value) => showDialog(
            context: context,
            builder: (_) => Container(
              child: Text("Finished!"),
            ),
          ),
        );
  }
}
