import 'dart:io';

import 'package:copia/Moor/table.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:copia/Utils/skeleton_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllPDFs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _bloc.watchAllPDfs(),
        builder: (_, AsyncSnapshot<List<PDFSData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SkeletonLoading();
          } else if (snapshot.data.length == 0) {
            return NoBooks();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              cacheExtent: 7,
              shrinkWrap: true,
              addSemanticIndexes: true,
              itemBuilder: (_, int index) {
                final _pdfSnapshot = snapshot.data[index];
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PDFScreen(index: index, snapshot: snapshot),
                      ),
                    ),
                    leading: Container(
                      height: 300,
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
                          image: FileImage(File(_pdfSnapshot.thumb)),
                        ),
                      ),
                    ),
                    title: Text(
                      '${_pdfSnapshot.pdfName}',
                      style: GoogleFonts.cormorant(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () =>
                          _deleteDialog(context, _bloc, _pdfSnapshot),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _deleteDialog(
      BuildContext context, AppDatabase bloc, PDFSData pdfSnapshot) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                bloc.deletePDf(pdfSnapshot);
                Navigator.pop(context);
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
