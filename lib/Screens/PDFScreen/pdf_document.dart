import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class PdfDocumentViewer extends StatelessWidget {
  final int index;

  PdfDocumentViewer(this.index);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        child: IconButton(
            icon: Icon(Icons.group_work), onPressed: () => _pdfDoc(context)));
  }

  void _pdfDoc(BuildContext context) {
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
                if (_pdf.documentPath == null) {
                  return Column(
                    children: <Widget>[
                      Container(
                        child: Text("You don't have a document for this PDF"),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.update),
                          onPressed: () async {
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
                            box.putAt(index, _modifiedPDF);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Loaded file is ${basename(_pdf.documentPath)}'),
                          Divider(),
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
                                              content:
                                                  Text('Document replaced!')));
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
