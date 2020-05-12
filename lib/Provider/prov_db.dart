import 'package:copia/Hive/database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ProviderDB with ChangeNotifier {
  void addBookmark(bool bookmark, {int index, PDFDB snapshot, int currPage}) {
    Hive.box('name').putAt(
      index,
      PDFDB(
        insertedDate: snapshot.insertedDate,
        lastSeenDate: snapshot.lastSeenDate,
        pdfAsset: snapshot.pdfAsset,
        pdfName: snapshot.pdfName,
        totalHours: snapshot.totalHours,
        thumb: snapshot.thumb,
        bookmarked: _listBookmark(snapshot, index, currPage, bookmark),
      ),
    );
  }

  List<int> _listBookmark(
      PDFDB snapshot, int index, int currentPage, bool bookmark) {
    if (snapshot.bookmarked != null) {
      if (bookmark) {
        return [currentPage, ...Hive.box('name')?.getAt(index)?.bookmarked];
      } else {
        return [...Hive.box('name')?.getAt(index)?.bookmarked]
          ..remove(currentPage);
      }
    } else {
      return [currentPage];
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
        lastVisitedPage: snapshot.lastVisitedPage,
        documentPath: snapshot.documentPath,
        pageNote: snapshot.pageNote,
        soundPath: snapshot.soundPath,
        thumb: snapshot.thumb,
        bookmarked: snapshot.bookmarked,
      ),
    );
  }
}
