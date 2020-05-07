import 'dart:io';

import 'package:copia/Moor/table.dart';
import 'package:copia/Utils/no_books.dart';
import 'package:copia/Utils/skeleton_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPDFs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<AppDatabase>(context);
    return Scaffold(
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
                    leading: Card(
                      elevation: 10,
                      shadowColor: Colors.black54,
                      child: Container(
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
                    ),
                    title: Text('${_pdfSnapshot.pdfName}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _bloc.deletePDf(_pdfSnapshot),
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
}
