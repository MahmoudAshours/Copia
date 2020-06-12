import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neumorphic/neumorphic.dart' as Neu;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class PdfDocumentViewer extends StatelessWidget {
  final int index;

  PdfDocumentViewer(this.index);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          color: Color(0xff26292D),
          intensity: 0.3,
          boxShape: NeumorphicBoxShape.circle()),
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            FontAwesomeIcons.fileWord,
            color: Colors.blueAccent,
          ),
        ),
        onTap: () => _pdfDoc(context),
      ),
    );
  }

  void _pdfDoc(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (_, StateSetter setState) {
            return Container(
              color: Color(0xff26292D),
              child: ValueListenableBuilder(
                valueListenable: Hive.box('pdfDB').listenable(),
                builder: (_, Box box, child) {
                  PDFDB _pdf = box.getAt(index);
                  if (_pdf.documentPath == null) {
                    return Container(
                      color: Color(0xff26292D),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 150,
                              height: 150,
                              child:
                                  SvgPicture.asset('assets/images/docs.svg')),
                          Center(
                            child: Container(
                              child: Text(
                                "You don't have a document for this PDF",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: 100,
                            height: 50,
                            child: GestureDetector(
                              child: Neu.NeuCard(
                                bevel: 2,
                                child: Center(
                                  child: Text(
                                    'Add document',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: Neu.NeumorphicDecoration(
                                    color: Color(0xffD44626),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onTap: () async {
                                File _file = await FilePicker.getFile(
                                    type: FileType.custom,
                                    allowedExtensions: ['doc', 'docx']);
                                final _modifiedPDF = PDFDB(
                                  bookmarked: _pdf.bookmarked,
                                  insertedDate: _pdf.insertedDate,
                                  lastSeenDate: _pdf.lastSeenDate,
                                  lastVisitedPage: _pdf.lastVisitedPage,
                                  pageNote: _pdf.pageNote,
                                  pdfAsset: _pdf.pdfAsset,
                                  pdfName: _pdf.pdfName,
                                  soundPath: _pdf.soundPath,
                                  thumb: _pdf.thumb,
                                  totalHours: _pdf.totalHours,
                                  documentPath: _file?.path ?? null,
                                );
                                box.putAt(index, _modifiedPDF);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Loaded file is ${basename(_pdf.documentPath)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 23,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffD3D4D5),
                                      ),
                                    ),
                                  ),
                                  Neu.NeuButton(
                                    child: FaIcon(FontAwesomeIcons.fileWord,
                                        color: Colors.redAccent),
                                    decoration: Neu.NeumorphicDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color(0xff26292D),
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                            Neumorphic(
                              child: Divider(
                                height: 2,
                              ),
                              style: NeumorphicStyle(
                                  color: Color(0xff26292D),
                                  depth: 2,
                                  lightSource: LightSource.top),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final _modifiedPDF = PDFDB(
                                      bookmarked: _pdf.bookmarked,
                                      insertedDate: _pdf.insertedDate,
                                      lastSeenDate: _pdf.lastSeenDate,
                                      lastVisitedPage: _pdf.lastVisitedPage,
                                      pageNote: _pdf.pageNote,
                                      pdfAsset: _pdf.pdfAsset,
                                      pdfName: _pdf.pdfName,
                                      soundPath: _pdf.soundPath,
                                      thumb: _pdf.thumb,
                                      totalHours: _pdf.totalHours,
                                      documentPath: _pdf.documentPath = null,
                                    );
                                    box.putAt(index, _modifiedPDF).whenComplete(
                                      () {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Document Deleted!')));
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        Text(
                                          'Delete file',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                InkWell(
                                  onTap: () async {
                                    File _file = await FilePicker.getFile(
                                        type: FileType.custom,
                                        allowedExtensions: ['doc', 'docx']);
                                    final _modifiedPDF = PDFDB(
                                      bookmarked: _pdf.bookmarked,
                                      insertedDate: _pdf.insertedDate,
                                      lastSeenDate: _pdf.lastSeenDate,
                                      lastVisitedPage: _pdf.lastVisitedPage,
                                      pageNote: _pdf.pageNote,
                                      pdfAsset: _pdf.pdfAsset,
                                      pdfName: _pdf.pdfName,
                                      soundPath: _pdf.soundPath,
                                      thumb: _pdf.thumb,
                                      totalHours: _pdf.totalHours,
                                      documentPath: _file.path ?? null,
                                    );
                                    box.putAt(index, _modifiedPDF).whenComplete(
                                      () {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Document replaced!')));
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.change_history,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          'Replace file',
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                InkWell(
                                  onTap: () => getContent(_pdf.documentPath),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          FlatIcons.document,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          'Open file',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Future getContent(path) async {
    try {
      OpenFile.open(path);
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
