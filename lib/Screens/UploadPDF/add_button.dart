import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Container(
      child: FloatingActionButton(
        onPressed: () async {
          final pdf = PDFDB(
            pdfName: _bloc.getPdfTitle,
            thumb: _bloc.getImage,
            pdfAsset: _bloc.getPdf,
            totalHours: 0,
            lastSeenDate: DateTime.now(),
            insertedDate: DateTime.now(),
          );
          var box = await Hive.openBox('name');
          box.add(pdf).whenComplete(() => Navigator.of(context).pop());
        },
        child: Text('Done!'),
      ),
    );
  }
}
