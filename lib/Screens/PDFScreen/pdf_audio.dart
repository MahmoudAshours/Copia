import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

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
        return Consumer<PDFScreenBloc>(
          builder: (_, bloc, __) => ValueListenableBuilder(
            valueListenable: Hive.box('pdfDB').listenable(),
            builder: (_, Box box, child) {
              PDFDB _pdf = box.getAt(index);
              if (_pdf.soundPath == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                          child: Text("You don't have an audio for this PDF")),
                    ),
                    Container(
                      child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.fileAudio,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          FilePicker.getFile(type: FileType.audio).then(
                            (value) {
                              final _modifiedPDF = PDFDB(
                                  bookmarked: _pdf.bookmarked,
                                  insertedDate: _pdf.insertedDate,
                                  lastSeenDate: _pdf.lastSeenDate,
                                  lastVisitedPage: _pdf.lastVisitedPage,
                                  pageNote: _pdf.pageNote,
                                  pdfAsset: _pdf.pdfAsset,
                                  pdfName: _pdf.pdfName,
                                  soundPath: value?.path ?? null,
                                  thumb: _pdf.thumb,
                                  totalHours: _pdf.totalHours,
                                  documentPath: _pdf.documentPath);
                              box.putAt(index, _modifiedPDF);
                            },
                          );
                          bloc.hideFabButton = false;
                          print(bloc.hideFab);
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
                              style: GoogleFonts.cormorant(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              final _modifiedPDF = PDFDB(
                                  bookmarked: _pdf.bookmarked,
                                  insertedDate: _pdf.insertedDate,
                                  lastSeenDate: _pdf.lastSeenDate,
                                  lastVisitedPage: _pdf.lastVisitedPage,
                                  pageNote: _pdf.pageNote,
                                  pdfAsset: _pdf.pdfAsset,
                                  pdfName: _pdf.pdfName,
                                  soundPath: null,
                                  thumb: _pdf.thumb,
                                  totalHours: _pdf.totalHours,
                                  documentPath: _pdf.documentPath);
                              box.putAt(index, _modifiedPDF);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
