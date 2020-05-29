import 'dart:io';

import 'package:copia/Hive/database.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:copia/Utils/owl_icons.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

class AllPDFs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () => _search(context, PDFsearchDelegate()),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('name').listenable(),
        builder: (_, Box snapshot, Widget child) {
          return ListView.builder(
            itemCount: snapshot.length,
            cacheExtent: 7,
            shrinkWrap: true,
            addSemanticIndexes: true,
            itemBuilder: (_, int index) {
              final _pdfSnapshot = snapshot.getAt(index);
              return Padding(
                padding: EdgeInsets.only(top: 20),
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PDFScreen(index: index, snapshot: _pdfSnapshot),
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
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.red,
                          ),
                          onPressed: () => _sharePdf(snapshot, index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _deleteDialog(context, snapshot, index),
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
    );
  }

  void _sharePdf(Box snapshot, index) async {
    final _pdf = snapshot.getAt(index);
    final _bytes = await File(_pdf.pdfAsset).readAsBytes();
    Share.file('Share PDF', "simplepdf.pdf", _bytes, 'image/jpg');
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

  void _search(context, delegate) {
    showSearch(context: context, delegate: delegate);
  }
}

class PDFsearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('name').listenable(),
      builder: (_, Box snapshot, __) {
        return ListView.builder(
          itemCount: snapshot.length,
          cacheExtent: 7,
          shrinkWrap: true,
          addSemanticIndexes: true,
          itemBuilder: (_, int index) {
            final PDFDB _pdfSnapshot = snapshot.getAt(index);
            if (_pdfSnapshot.pdfName.contains(query) ||
                _pdfSnapshot.pdfAsset.contains(query))
              return Padding(
                padding: EdgeInsets.only(top: 20),
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PDFScreen(index: index, snapshot: _pdfSnapshot),
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
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.red,
                          ),
                          onPressed: () => _sharePdf(snapshot, index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _deleteDialog(context, snapshot, index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            return Container(
              child: Icon(Owl.animal),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('name').listenable(),
      builder: (_, Box snapshot, __) {
        return ListView.builder(
          itemCount: snapshot.length,
          cacheExtent: 7,
          shrinkWrap: true,
          addSemanticIndexes: true,
          itemBuilder: (_, int index) {
            final PDFDB _pdfSnapshot = snapshot.getAt(index);
            if (_pdfSnapshot.pdfName.contains(query) ||
                basename(_pdfSnapshot.pdfAsset).contains(query))
              return Padding(
                padding: EdgeInsets.only(top: 20),
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PDFScreen(index: index, snapshot: _pdfSnapshot),
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
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.red,
                          ),
                          onPressed: () => _sharePdf(snapshot, index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _deleteDialog(context, snapshot, index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            return Container(
              child: Center(child: Icon(Owl.animal)),
            );
          },
        );
      },
    );
  }

  void _sharePdf(Box snapshot, index) async {
    final _pdf = snapshot.getAt(index);
    final _bytes = await File(_pdf.pdfAsset).readAsBytes();
    Share.file('Share PDF', "simplepdf.pdf", _bytes, 'image/jpg');
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
