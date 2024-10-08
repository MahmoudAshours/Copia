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
      width: 100,
      child: TextButton(
        onPressed: () async {
          if (_bloc.getPdf == null)
            return showDialog(
              context: context,
              builder: (_) => Material(
                type: MaterialType.transparency,
                child: Dialog(
                  insetAnimationCurve: Curves.bounceOut,
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "You can't leave it empty!",
                          style: TextStyle(
                            fontFamily: 'cormorant',
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: Color(0xffAAABAD),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                color: Color(0xf2EA4F2C), fontSize: 18),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          final pdf = PDFDB(
            pdfName: _bloc.getPdfTitle ??
                '${basename(_bloc.getPdf.substring(0, 8))}',
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
        child: Text(
          'Done!',
          style: TextStyle(
            fontFamily: 'cormorant',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
