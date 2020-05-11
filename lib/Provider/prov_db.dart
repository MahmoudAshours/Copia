import 'package:copia/Hive/database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ProviderDB with ChangeNotifier {
   void addBookmark({int index, PDFDB snapshot, int currPage}) {
    Hive.box('name').putAt(
        index,
        PDFDB(
          insertedDate: snapshot.insertedDate,
          lastSeenDate: snapshot.lastSeenDate,
          pdfAsset: snapshot.pdfAsset,
          pdfName: snapshot.pdfName,
          totalHours: snapshot.totalHours,
          thumb: snapshot.thumb,
          bookmarked: _listBookmark(snapshot, index, currPage),
        ));
  }

  List<int> _listBookmark(PDFDB snapshot, int index, int currentpage) {
    if (snapshot.bookmarked != null) {
      return [currentpage, ...Hive.box('name')?.getAt(index)?.bookmarked];
    } else {
      return [currentpage];
    }
  }

  Future<void> updateLastSeen(PDFDB snapshot, int index) {
    return Hive.box('name').putAt(
      index,
      PDFDB(
          insertedDate: snapshot.insertedDate,
          lastSeenDate: DateTime.now(),
          pdfAsset: snapshot.pdfAsset,
          pdfName: snapshot.pdfName,
          totalHours: snapshot.totalHours,
          thumb: snapshot.thumb,
          bookmarked: snapshot.bookmarked),
    );
  }
}
