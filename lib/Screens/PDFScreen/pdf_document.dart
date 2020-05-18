import 'dart:io';
import 'dart:typed_data';

import 'package:copia/Hive/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
                          child:
                              Text("You don't have a document for this PDF")),
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
                    child: FutureBuilder(
                      future: getContent(_pdf.documentPath),
                      builder: (_, snapshot) => Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _speak(snapshot.data),
                            child: Icon(Icons.ac_unit),
                          ),
                          Container(
                            child: SelectableText('${snapshot.data}'),
                          ),
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
      final file = File(path);
      // Read the file.
      Uint8List contents = await file.readAsBytes();
      String s = new String.fromCharCodes(contents);
      return s;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future _speak(text) async {
    FlutterTts flutterTts = FlutterTts();
    print(await flutterTts.getVoices);
    print(await flutterTts.getLanguages);

    flutterTts
      ..setPitch(1)
      ..setSpeechRate(1);

    await flutterTts.speak(text);
  }
}
