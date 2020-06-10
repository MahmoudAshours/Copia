import 'dart:io';

import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neumorphic/neumorphic.dart';

class BookCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: ValueListenableBuilder(
          valueListenable: Hive.box('pdfDB').listenable(),
          builder: (_, Box snapshot, Widget child) {
            if (snapshot.isEmpty) return NoBooks();
            return ListView.separated(
              separatorBuilder: (_, int i) => VerticalDivider(width: 20),
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.length < 5 ? snapshot.length : 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                final _pdf = snapshot.getAt(index);
                return FlipCard(
                  direction: FlipDirection.VERTICAL,
                  back: _showBookDetails(snapshot, index, context),
                  front: Center(
                    child: Column(
                      children: <Widget>[
                        NeuCard(
                          bevel: 20,
                          decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff19170F),
                          ),
                          curveType: CurveType.flat,
                          child: Container(
                            child: Align(
                              child: Container(
                                width: 200,
                                height: 240,
                              ),
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(_pdf.thumb)),
                              ),
                            ),
                          ),
                        ),
                        NeuText(
                          '${_pdf.pdfName}',
                          spread: 1,
                          depth: 10,
                          parentColor: Colors.white30,
                          style: GoogleFonts.cormorant(
                            fontSize: 20,
                            color: Color(0xffAAABAD),
                          ),
                        ),
                      ],
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

  Column _showBookDetails(
      Box<dynamic> snapshot, int index, BuildContext context) {
    final _pdf = snapshot.getAt(index);
    return Column(
      children: <Widget>[
        NeuCard(
          bevel: 0.1,
          decoration: NeumorphicDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white30,
          ),
          curveType: CurveType.concave, 
          child: Container(
            width: 200,
            height: 300,
            color: const Color(0xff26292D),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            SafeArea(
                              minimum: EdgeInsets.all(30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(_pdf.thumb)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 150,
                              child: SafeArea(
                                minimum: EdgeInsets.all(30.0),
                                child: Container(
                                  width: 100,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Color(0xffACACAE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 40.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Created on : ${_pdf.insertedDate.day}/${_pdf.insertedDate.month}/${_pdf.insertedDate.year}',
                        style: GoogleFonts.cormorant(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PDFScreen(
                              snapshot: snapshot.getAt(index), index: index))),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: NeuText(
                            'View pdf',
                            depth: 10,
                            spread: 1,
                            style: GoogleFonts.cormorant(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
