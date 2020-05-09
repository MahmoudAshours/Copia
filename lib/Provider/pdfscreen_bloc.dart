import 'package:flutter/foundation.dart';

class PDFScreenBloc with ChangeNotifier {
  String _path = '';
  set path(String path) {
    _path = path;
    notifyListeners();
  }

  get path => _path;
}
