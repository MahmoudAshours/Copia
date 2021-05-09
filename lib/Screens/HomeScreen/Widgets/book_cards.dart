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
                  delay: Duration(milliseconds: index * 700),
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
                          Container(
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
                          Text(
                            '${_pdf.pdfName}',
                            style: TextStyle(
                              fontFamily: 'cormorant',
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
        SizedBox.expand(
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
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PDFScreen(
                                snapshot: snapshot.getAt(index), index: index),
                          ),
                        ),
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
                      child: TextButton(
                        onPressed: () => _sharePdf(snapshot, index),
                        child: FaIcon(FontAwesomeIcons.share,
                            color: Colors.orangeAccent, size: 20),
                      ),
                    ),
                    BounceInUp(
                      duration: Duration(seconds: 3),
                      animate: _animateBack,
                      child: TextButton(
                          onPressed: () =>
                              _deleteDialog(context, snapshot, index),
                          child: FaIcon(FontAwesomeIcons.trash,
                              color: Colors.redAccent, size: 20)),
                    )
                  ],
                ),
              ],
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
            TextButton(
              onPressed: () {
                snapshot
                    .deleteAt(index)
                    .whenComplete(() => Navigator.pop(context));
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
