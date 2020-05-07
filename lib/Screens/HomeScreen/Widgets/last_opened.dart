import 'dart:io';

import 'package:copia/Moor/table.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LastOpened extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<AppDatabase>(context);
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
            StreamBuilder<PDFSData>(
              stream: _bloc.checkLastSeen(),
              builder: (_, AsyncSnapshot<PDFSData> snapshot) {
                final _pdf = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            PDFScreen(lastOpenedSnapshot: snapshot))),
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
                                    style: GoogleFonts.cormorant(
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
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
