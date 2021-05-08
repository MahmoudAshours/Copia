import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LastOpened extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Last book opened',
                style: TextStyle(
                    fontFamily: 'cormorant',
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            ValueListenableBuilder(
              valueListenable: Hive.box('pdfDB').listenable(),
              builder: (_, Box snapshot, widget) {
                if (snapshot.isEmpty) return Container();
                List<PDFDB> _pdfs =
                    Hive.box('pdfDB').values.toList().cast<PDFDB>();
                _pdfs.sort((b, a) => a.lastSeenDate.compareTo(b.lastSeenDate));
                final _pdf = _pdfs[0];
                return TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PDFScreen(
                        snapshot: _pdf,
                        index: Hive.box('pdfDB')
                            .values
                            .toList()
                            .cast<PDFDB>()
                            .indexOf(_pdf),
                      ),
                    ),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(File(_pdf.thumb)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                child: Text(
                                  '${_pdf.pdfName}',
                                  style: TextStyle(
                                      fontFamily: 'cormorant',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xf2EA4F2C)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
