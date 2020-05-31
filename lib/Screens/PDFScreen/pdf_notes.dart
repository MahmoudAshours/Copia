import 'package:copia/Hive/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PdfNotes extends StatefulWidget {
  final int index;
  final int currentPage;
  PdfNotes({this.index, this.currentPage});
  @override
  _PdfNotesState createState() => _PdfNotesState();
}

class _PdfNotesState extends State<PdfNotes> {
  TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      child: IconButton(
        icon: Icon(Icons.note),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (_, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('name').listenable(),
                      builder: (_, Box snap, __) {
                        final PDFDB _pdf = snap.getAt(widget.index);
                        if (_pdf.pageNote == null ||
                            !_pdf.pageNote.keys.contains(widget.currentPage)) {
                          return Column(
                            children: <Widget>[
                              SafeArea(
                                minimum: EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: 30,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: Color(0xff584846),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                              ),
                              Text('Add your notes here!'),
                              TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
                                controller: _controller,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  final _modifiedPDF = PDFDB(
                                    bookmarked: _pdf.bookmarked,
                                    insertedDate: _pdf.insertedDate,
                                    lastSeenDate: _pdf.lastSeenDate,
                                    lastVisitedPage: _pdf.lastVisitedPage,
                                    pageNote: _listNotes(_pdf, widget.index,
                                        widget.currentPage, _controller.text),
                                    pdfAsset: _pdf.pdfAsset,
                                    pdfName: _pdf.pdfName,
                                    soundPath: _pdf.soundPath,
                                    thumb: _pdf.thumb,
                                    totalHours: _pdf.totalHours,
                                    documentPath: _pdf.documentPath,
                                  );
                                  Hive.box('name')
                                      .putAt(widget.index, _modifiedPDF);
                                },
                              )
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                      '${_pdf.pageNote[widget.currentPage]}'),
                                ),
                                GestureDetector(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    final _modifiedPDF = PDFDB(
                                      bookmarked: _pdf.bookmarked,
                                      insertedDate: _pdf.insertedDate,
                                      lastSeenDate: _pdf.lastSeenDate,
                                      lastVisitedPage: _pdf.lastVisitedPage,
                                      pageNote: _pdf.pageNote
                                        ..remove(widget.currentPage),
                                      pdfAsset: _pdf.pdfAsset,
                                      pdfName: _pdf.pdfName,
                                      soundPath: _pdf.soundPath,
                                      thumb: _pdf.thumb,
                                      totalHours: _pdf.totalHours,
                                      documentPath: _pdf.documentPath,
                                    );
                                    Hive.box('name')
                                        .putAt(widget.index, _modifiedPDF);
                                  },
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<int, String> _listNotes(
      PDFDB snapshot, int index, int currentPage, String note) {
    if (snapshot.pageNote != null) {
      snapshot.pageNote.putIfAbsent(currentPage, () => note);
      return snapshot.pageNote;
    } else {
      final Map<int, String> map = {};
      map[currentPage] = note;
      return map;
    }
  }
}
