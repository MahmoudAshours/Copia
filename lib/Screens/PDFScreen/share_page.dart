import 'dart:ui';

import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pdfProvider = Provider.of<PDFScreenBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _sharePage(context, _pdfProvider),
        child: FaIcon(FontAwesomeIcons.share,color:Colors.cyan),
      ),
    );
  }

  Future<void> _sharePage(
      BuildContext context, PDFScreenBloc pdfProvider) async {
    RenderRepaintBoundary boundary =
        pdfProvider.scr.currentContext.findRenderObject();
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    await Share.file(
        'Share Copia PDF page', 'copiaPdf.jpg', pngBytes, 'image/jpg',
        text: "Check this Page! #Copia");
  }
}
