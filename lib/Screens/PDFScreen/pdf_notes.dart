import 'package:copia/Hive/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neumorphic/neumorphic.dart' as Neu;

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
    return GestureDetector(
      child: Neumorphic(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FaIcon(
            FontAwesomeIcons.quoteLeft,
            color: Color(0xff5EF0C5),
            size: 17,
          ),
        ),
        style: NeumorphicStyle(
            color: Color(0xff26292D),
            intensity: 0.3,
            boxShape: NeumorphicBoxShape.circle()),
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) {
              return Container(
                color: const Color(0xff26292D),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('pdfDB').listenable(),
                    builder: (_, Box snap, __) {
                      final PDFDB _pdf = snap.getAt(widget.index);
                      if (_pdf.pageNote == null ||
                          !_pdf.pageNote.keys.contains(widget.currentPage)) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Add your note',
                                    style: TextStyle(
                                      fontSize: 23,
                                      letterSpacing: 1.3,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffD3D4D5),
                                    ),
                                  ),
                                  Neu.NeuButton(
                                    child: FaIcon(FontAwesomeIcons.quoteRight,
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
                            TextField(
                              maxLines: 100,
                              minLines: 10,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              controller: _controller,
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: 80,
                              child: Neu.NeuButton(
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
                                  Hive.box('pdfDB')
                                      .putAt(widget.index, _modifiedPDF);
                                },
                                decoration: Neu.NeumorphicDecoration(
                                    color: const Color(0xff26292D),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Your note',
                                        style: TextStyle(
                                          fontSize: 23,
                                          letterSpacing: 1.3,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffD3D4D5),
                                        ),
                                      ),
                                      Neu.NeuButton(
                                        child: FaIcon(
                                            FontAwesomeIcons.quoteRight,
                                            color: Colors.blueAccent),
                                        decoration: Neu.NeumorphicDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xff26292D),
                                        ),
                                        onPressed: null,
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
                                Divider(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: SelectableText(
                                      '${_pdf.pageNote[widget.currentPage]}',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Neumorphic(
                                  style: NeumorphicStyle(
                                      color: Color(0xff26292D),
                                      depth: 2,
                                      lightSource: LightSource.top),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      child: FaIcon(
                                        FontAwesomeIcons.trashAlt,
                                        color: Colors.redAccent,
                                      ),
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
                                        Hive.box('pdfDB')
                                            .putAt(widget.index, _modifiedPDF)
                                            .whenComplete(
                                          () {
                                            _controller.clear();
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
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
