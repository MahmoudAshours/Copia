import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
                return Column(
                  children: <Widget>[
                    Container(
                        child: Text("You don't have a document for this PDF")),
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
              },
            );
          },
        );
      },
    );
  }

  // Future _speak() async {
  //   FlutterTts flutterTts = FlutterTts();
  //   print(await flutterTts.getVoices);
  //   print(await flutterTts.getLanguages);

  //   flutterTts
  //     ..setVoice("en-GB-language")
  //     ..setLanguage('ja-JP')
  //     ..setPitch(1)
  //     ..setSpeechRate(1);

  //   await flutterTts.speak(
  //       "新型コロナウイルス対策で、与野党の一部議員が提案する国会審議のオンライン化の検討が進まない。欧州の議会では、一部でウェブ会議や電子投票の導入が実現。国内でも、企業など社会の様々な場でオンライン化が進むのに、なぜ国会の腰は重いのか");
  // }
}
