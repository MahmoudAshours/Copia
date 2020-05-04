import 'dart:convert';

import 'package:copia/Moor/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

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
          builder: (_, AsyncSnapshot<List<PDFSData>> snapshot) => snapshot
                      .connectionState ==
                  ConnectionState.waiting
              ? _skeleteon()
              : ListView.separated(
                  separatorBuilder: (_, int i) => VerticalDivider(
                    width: 20,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, int index) => Container(
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
                                child: Text('${snapshot.data[3].pdfName}')),
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
                            image: MemoryImage(
                              base64Decode(snapshot.data[3].thumb.toString()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  _skeleteon() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SkeletonAnimation(
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                        child: SkeletonAnimation(
                          child: Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: SkeletonAnimation(
                            child: Container(
                              width: 60,
                              height: 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
