import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Container(
      child: FloatingActionButton(
        onPressed: () async {
          if (_bloc.getPdf == null) return;
          final pdf = PDFDB(
            pdfName: _bloc.getPdfTitle ?? '${basename(_bloc.getPdf)}',
            thumb: _bloc?.getImage ?? 'assets/images/onboarding3.png',
            pdfAsset: _bloc.getPdf,
            totalHours: 0,
            lastSeenDate: DateTime.now(),
            bookmarked: [],
            documentPath: null,
            lastVisitedPage: 0,
            soundPath: null,
            insertedDate: DateTime.now(),
          );
          var box = await Hive.openBox('pdfDB');
          box.add(pdf).whenComplete(() {
            _bloc.nullify();
            Navigator.of(context).pop();
          });
        },
        child: Text('Done!'),
      ),
    );
  }
}
