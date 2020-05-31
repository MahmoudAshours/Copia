import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

class PdfAudio extends StatelessWidget {
  final int index;
  PdfAudio(this.index);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.headset), onPressed: () => _pdfAudio(context));
  }

  void _pdfAudio(context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (_, StateSetter setState) {
            return ValueListenableBuilder(
              valueListenable: Hive.box('name').listenable(),
              builder: (_, Box box, child) {
                PDFDB _pdf = box.getAt(index);
                if (box.getAt(index).soundPath == null) {
                  return Column(
                    children: <Widget>[
                      Container(
                          child: Text("You don't have an audio for this PDF")),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.update),
                          onPressed: () async {
                            File _file =
                                await FilePicker.getFile(type: FileType.audio);
                            final _modifiedPDF = PDFDB(
                                bookmarked: _pdf.bookmarked,
                                insertedDate: _pdf.insertedDate,
                                lastSeenDate: _pdf.lastSeenDate,
                                lastVisitedPage: _pdf.lastVisitedPage,
                                pageNote: _pdf.pageNote,
                                pdfAsset: _pdf.pdfAsset,
                                pdfName: _pdf.pdfName,
                                soundPath: _file.path ?? null,
                                thumb: _pdf.thumb,
                                totalHours: _pdf.totalHours,
                                documentPath: _pdf.documentPath);
                            box.putAt(index, _modifiedPDF);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: 0.1,
                          child: FaIcon(
                            FontAwesomeIcons.music,
                            color: Colors.purple,
                            size: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'You have audio file ${basename(_pdf.soundPath)}',
                                style: GoogleFonts.cormorant(fontSize: 28),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete), onPressed: () {})
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
