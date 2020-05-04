import 'package:copia/Moor/table.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    final _dbloc = Provider.of<AppDatabase>(context);
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SafeArea(
              child: GestureDetector(
                onTap: () {
                  _bloc.getImageFromGallery().then(
                    (value) {
                      final _pdfValue = PDFSData(
                        pdfName: 'null',
                        thumb: '$value',
                        id: null,
                        pdfAsset: 'hello',
                        totalHours: 0,
                        insertedDate: DateTime.now(),
                      );
                      _dbloc.insertPDF(_pdfValue);
                    },
                  );
                },
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.art_track,
                      size: 50,
                    )),
              ),
            ),
          ],
        ),
      ),
      navigationBar: CupertinoNavigationBar(),
    );
  }
}
