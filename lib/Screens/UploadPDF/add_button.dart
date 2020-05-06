import 'package:copia/Moor/table.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    final _dbloc = Provider.of<AppDatabase>(context);

    return Container(
      child: FloatingActionButton(
        onPressed: () {
          final _pdf = PDFSData(
            id: null,
            pdfName: _bloc.getPdfTitle,
            thumb: _bloc.getImage,
            pdfAsset: _bloc.getPdf,
            totalHours: 0,
            lastSeenDate: DateTime.now(),
            insertedDate: DateTime.now(),
          );
          _dbloc.insertPDF(_pdf).then(
                (value) => Navigator.of(context).pop(),
              );
        },
        child: Text('Done!'),
      ),
    );
  }
}
