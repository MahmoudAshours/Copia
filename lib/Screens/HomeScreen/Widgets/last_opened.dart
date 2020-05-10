import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                style: GoogleFonts.cormorant(
                    fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            ValueListenableBuilder(
              valueListenable: Hive.box('name').listenable(),
              builder: (_, Box snapshot, widget) {
                if (snapshot.isEmpty) return NoBooks();
                List<PDFDB> _pdfs =
                    Hive.box('name').values.toList().cast<PDFDB>();
                _pdfs.sort((b, a) => a.lastSeenDate.compareTo(b.lastSeenDate));
                final _pdf = _pdfs[0];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PDFScreen(
                        lastOpenedSnapshot: _pdf,
                        index: Hive.box('name')
                            .values
                            .toList()
                            .cast<PDFDB>()
                            .indexOf(_pdf),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff584846),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            height: 50,
                            foregroundDecoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white10,
                                  spreadRadius: 0.1,
                                  blurRadius: 3,
                                  offset: Offset.zero,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffEEEEED),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset.zero,
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
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
                                      color: Colors.white),
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
