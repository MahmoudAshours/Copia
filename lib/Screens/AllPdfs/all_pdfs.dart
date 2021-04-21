import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:copia/Hive/database.dart';
import 'package:copia/Screens/PDFScreen/pdfscreen.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

class AllPDFs extends StatefulWidget {
  @override
  _AllPDFsState createState() => _AllPDFsState();
}

class _AllPDFsState extends State<AllPDFs> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
        defaultTextColor: Color(0xFF3E3E3E),
        baseColor: const Color(0xff26292D),
        intensity: 0.3,
        lightSource: LightSource.bottomRight,
        depth: 3,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xff26292D),
        appBar: NeumorphicAppBar(
          buttonStyle: NeumorphicStyle(color: const Color(0xff26292D)),
          color: const Color(0xff26292D),
          textStyle: TextStyle(color: Colors.red),
          actions: <Widget>[
            GestureDetector(
              onTap: () => _search(context, PDFsearchDelegate()),
              child:
                  SafeArea(child: Icon(Icons.search, color: Colors.cyanAccent)),
            )
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box('pdfDB').listenable(),
          builder: (_, Box snapshot, Widget child) {
            if (snapshot.isEmpty)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Center(
                      child: Text('There is no books'),
                    ),
                  ),
                ],
              );
            return Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.length,
                shrinkWrap: true,
                key: _listKey,
                itemBuilder: (BuildContext context, int index) {
                  final _pdfSnapshot = snapshot.getAt(index);
                  return _buildListItem(context, index, _pdfSnapshot, snapshot);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  _buildListItem(
      BuildContext context, int index, PDFDB _pdfSnapshot, Box snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => PDFScreen(index: index, snapshot: _pdfSnapshot)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FadeInLeft(
                delay: Duration(milliseconds: 500 * index),
                child: Neumorphic(
                  curve: Curves.bounceInOut,
                  style: NeumorphicStyle(
                      color: const Color(0xff26292D),
                      border: NeumorphicBorder(color: Colors.black),
                      lightSource: LightSource.top,
                      shadowDarkColor: Colors.black),
                  child: Container(
                    height: 300,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(_pdfSnapshot.thumb)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '${_pdfSnapshot.pdfName}',
              style: TextStyle(
                  fontFamily: 'cormorant',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: BounceInUp(
                        child: GestureDetector(
                          child: NeumorphicIcon(
                            Icons.share,
                            style: NeumorphicStyle(color: Color(0xffAE883E)),
                            size: 20,
                          ),
                          onTap: () => _sharePdf(snapshot, index),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deleteDialog(context, snapshot, index),
                      child: BounceInUp(
                        child: NeumorphicIcon(
                          Icons.delete,
                          style: NeumorphicStyle(color: Color(0xffE03B3C)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sharePdf(Box snapshot, index) async {
    final _pdf = snapshot.getAt(index);
    final _bytes = await File(_pdf.pdfAsset).readAsBytes();
    Share.file(
        'Share PDF', "${basename(_pdf.pdfAsset)}", _bytes, 'application/pdf');
  }

  void _deleteDialog(BuildContext context, Box snapshot, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await snapshot.deleteAt(index);
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

  void _search(context, delegate) =>
      showSearch(context: context, delegate: delegate);
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
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xff26292D),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('pdfDB').listenable(),
        builder: (_, Box snapshot, __) {
          return ListView.builder(
            itemCount: snapshot.length,
            cacheExtent: 7,
            shrinkWrap: true,
            addSemanticIndexes: true,
            itemBuilder: (_, int index) {
              final PDFDB _pdfSnapshot = snapshot.getAt(index);
              if (_pdfSnapshot.pdfName
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  basename(_pdfSnapshot.pdfAsset)
                      .toLowerCase()
                      .contains(query.toLowerCase()))
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
                      style: TextStyle(
                          fontFamily: 'cormorant',
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
              return Container();
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xff26292D),
        child: ValueListenableBuilder(
          valueListenable: Hive.box('pdfDB').listenable(),
          builder: (_, Box snapshot, __) {
            return ListView.builder(
              itemCount: snapshot.length,
              cacheExtent: 7,
              shrinkWrap: true,
              addSemanticIndexes: true,
              itemBuilder: (_, int index) {
                final PDFDB _pdfSnapshot = snapshot.getAt(index);
                if (_pdfSnapshot.pdfName
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    basename(_pdfSnapshot.pdfAsset.toLowerCase())
                        .contains(query.toLowerCase()))
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
                        style: TextStyle(
                            fontFamily: 'cormorant',
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
                return Container();
              },
            );
          },
        ));
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
