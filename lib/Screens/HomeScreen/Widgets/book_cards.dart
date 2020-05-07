import 'dart:io';

import 'package:copia/Moor/table.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:copia/Utils/skeleton_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<AppDatabase>(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: StreamBuilder(
          stream: _bloc.watchAllPDfs(),
          builder: (_, AsyncSnapshot<List<PDFSData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonLoading();
            } else if (snapshot.data.length == 0) {
              return NoBooks();
            } else {
              return ListView.separated(
                separatorBuilder: (_, int i) => VerticalDivider(width: 20),
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length < 5 ? snapshot.data.length : 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) => GestureDetector(
                  onTap: () => _showBookDetails(snapshot, index, context),
                  child: Container(
                    width: 200,
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 200,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                width: 200,
                                height: 50,
                                color: Colors.grey[300],
                                child: Center(
                                    child: Text(
                                        '${snapshot.data[index].pdfName}')))),
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
                            image: FileImage(File(snapshot.data[index].thumb)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showBookDetails(snapshot, index, context) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
                                    image: FileImage(
                                      File(snapshot.data[index].thumb),
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
                    Text('${snapshot.data[index].pdfName}')
                  ],
                ),
                Text('${snapshot.data[index].insertedDate}'),
                Text('${snapshot.data[index].lastSeenDate}'),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            PDFScreen(snapshot: snapshot, index: index))),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text('View pdf')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
