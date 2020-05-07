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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          PDFScreen(index: index, snapshot: snapshot))),
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
}
