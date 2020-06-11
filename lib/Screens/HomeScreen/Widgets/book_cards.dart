import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:path/path.dart';

class BookCards extends StatefulWidget {
  @override
  _BookCardsState createState() => _BookCardsState();
}

class _BookCardsState extends State<BookCards> {
  bool _animateBack = false;
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
                return FadeInUp(
                  animate: true,
                  delay: Duration(milliseconds: index*700),
                  child: FlipCard(
                    direction: FlipDirection.VERTICAL,
                    onFlipDone: (done) {
                       setState(() {
                        _animateBack = !done;
                      });
                    },
                    back: _showBookDetails(snapshot, index, context),
                    front: Center(
                      child: Column(
                        children: <Widget>[
                          NeuCard(
                            bevel: 10,
                            decoration: NeumorphicDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xff26292D),
                              border: Border.all(
                                  color: const Color(0xff26292D), width: 8),
                            ),
                            curveType: CurveType.convex,
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
                            style:  TextStyle(fontFamily: 'cormorant',
                              fontSize: 20,
                              color: Color(0xffAAABAD),
                            ),
                          ),
                        ],
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
        NeuCard(
          width: 200,
          height: 300,
          decoration: NeumorphicDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff26292D),
          ),
          curveType: CurveType.convex,
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
                                NeuCard(
                                  height: 150,
                                  bevel: 20,
                                  width: 100,
                                  decoration: NeumorphicDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff26292D),
                                  ),
                                  curveType: CurveType.convex,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(_pdf.thumb)),
                                      ),
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
                              child: NeuCard(
                                width: 100,
                                height: 10,
                                curveType: CurveType.convex,
                                decoration: NeumorphicDecoration(
                                  color: const Color(0xff26292D),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BounceInUp(
                        duration: Duration(seconds: 1),
                        animate: _animateBack,
                        child: NeuButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PDFScreen(
                                  snapshot: snapshot.getAt(index),
                                  index: index),
                            ),
                          ),
                          decoration: NeumorphicDecoration(
                              color: const Color(0xff26292D),
                              borderRadius: BorderRadius.circular(10)),
                          child: FaIcon(FontAwesomeIcons.bookReader,
                              color: Colors.greenAccent, size: 20),
                        ),
                      ),
                      BounceInUp(
                        duration: Duration(seconds: 2),
                        animate: _animateBack,
                        controller: (controller) {
                          if (_animateBack) controller.forward();
                          controller.reverse();
                        },
                        manualTrigger: true,
                        child: NeuButton(
                          onPressed: () => _sharePdf(snapshot, index),
                          decoration: NeumorphicDecoration(
                              color: const Color(0xff26292D),
                              borderRadius: BorderRadius.circular(10)),
                          child: FaIcon(FontAwesomeIcons.share,
                              color: Colors.orangeAccent, size: 20),
                        ),
                      ),
                      BounceInUp(
                        duration: Duration(seconds: 3),
                        animate: _animateBack,
                        child: NeuButton(
                            onPressed: () =>
                                _deleteDialog(context, snapshot, index),
                            decoration: NeumorphicDecoration(
                                color: const Color(0xff26292D),
                                borderRadius: BorderRadius.circular(10)),
                            child: FaIcon(FontAwesomeIcons.trash,
                                color: Colors.redAccent, size: 20)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sharePdf(Box snapshot, index) async {
    final _pdf = snapshot.getAt(index);
    final _bytes = await File(_pdf.pdfAsset).readAsBytes();
    Share.file(
        'Share PDF', "${basename(_pdf.pdfAsset)}", _bytes, 'application/pdf');
  }

  void _deleteDialog(BuildContext context, Box snapshot, index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                snapshot
                    .deleteAt(index)
                    .whenComplete(() => Navigator.pop(context));
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
