import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class BookmarkList extends StatelessWidget {
  final int index;
  final PdfController pdfController;
  BookmarkList({this.index, this.pdfController});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        FontAwesomeIcons.listOl,
      ),
      onTap: () => _bookmarksSheet(context),
    );
  }

  void _bookmarksSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 400,
        decoration: BoxDecoration(
            color: const Color(0xff26292D),
            borderRadius: BorderRadius.circular(40)),
        child: Stack(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: Hive.box('pdfDB').listenable(),
              builder: (_, Box snap, __) {
                if (snap.getAt(index).bookmarked == null ||
                    snap.getAt(index).bookmarked.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'You dont have any favorites yet!',
                          style: TextStyle(
                              color: Color(0xffBFC0C2),
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          width: 150,
                          height: 150,
                          child:
                              SvgPicture.asset('assets/images/heartbroken.svg'))
                    ],
                  );
                }
                return Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Favorites',
                            style: TextStyle(
                              fontSize: 23,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffD3D4D5),
                            ),
                          ),
                          TextButton(
                            child:
                                Icon(Icons.favorite, color: Colors.redAccent),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Container(
                      height: 400,
                      child: ListView(
                        children: snap.getAt(index).bookmarked.map<Widget>(
                          (int pageNumber) {
                            return ListTile(
                              title: Text(
                                'Page number $pageNumber',
                                style: GoogleFonts.cagliostro(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              onTap: () => pdfController
                                  .animateToPage(
                                    pageNumber,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeInOutBack,
                                  )
                                  .then((_) => Navigator.of(context).pop()),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
