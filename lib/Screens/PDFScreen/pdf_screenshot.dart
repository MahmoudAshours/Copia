import 'dart:ui';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PdfScreenshot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pdfProvider = Provider.of<PDFScreenBloc>(context);
    return Tooltip(
      message: 'Save this page to gallery',
      child: GestureDetector(
        onTap: () => _takeScreenshot(context, _pdfProvider),
        child: Icon(Icons.camera_alt, color: Colors.amber),
      ),
    );
  }

  Future<void> _takeScreenshot(
      BuildContext context, PDFScreenBloc pdfProvider) async {
    if (await Permission.storage.request().isGranted) {
      RenderRepaintBoundary boundary =
          pdfProvider.scr.currentContext.findRenderObject();
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();
      ImageGallerySaver.saveImage(pngBytes).then(
        (_) => Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to gallery!'),
          ),
        ),
      );
    } else {
      await Permission.storage.request();
    }
  }
}
