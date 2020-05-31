import 'dart:io';

import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: ValueListenableBuilder(
          valueListenable: Hive.box('name').listenable(),
          builder: (_, Box snapshot, Widget child) {
            if (snapshot.isEmpty) return NoBooks();
            return ListView.separated(
              separatorBuilder: (_, int i) => VerticalDivider(width: 20),
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.length < 5 ? snapshot.length : 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                final _pdf = snapshot.getAt(index);
                return GestureDetector(
                  onTap: () {},
                  child: FlipCard(
                    direction: FlipDirection.VERTICAL,
                    back: _showBookDetails(snapshot, index, context),
                    front: Center(
                      child: Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 400,
                            height: 50,
                            color: Colors.grey[300],
                            child: Center(
                              child: Text(
                                '${_pdf.pdfName}',
                                style: GoogleFonts.cormorant(
                                  fontSize: 40,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
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
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xffEEEEED),
          ),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff584846),
                                      spreadRadius: 0.3,
                                      blurRadius: 2,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${_pdf.pdfName}',
                            style: GoogleFonts.cormorant(
                                fontWeight: FontWeight.w700, fontSize: 26),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.0),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PDFScreen(
                                    snapshot: snapshot.getAt(index),
                                    index: index))),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'View pdf',
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
                  SafeArea(
                    minimum: const EdgeInsets.all(8.0),
                    child: Text(
                      'Last opened on :  ${_pdf.lastSeenDate.day}/${_pdf.lastSeenDate.month}/${_pdf.lastSeenDate.year}',
                      style: GoogleFonts.cormorant(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
