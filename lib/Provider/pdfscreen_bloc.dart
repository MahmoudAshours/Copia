import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PDFScreenBloc with ChangeNotifier {
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = '';

  var scr = GlobalKey();

  set currentPage(int page) {
    _currentPage = page;
    print(_currentPage);
    notifyListeners();
  }

  set error(String errmsg) {
    _errorMessage = errmsg;
    notifyListeners();
  }

  set ready(bool isReady) {
    _isReady = isReady;
    notifyListeners();
  }

  int get currpage => _currentPage;

  String get getError => _errorMessage;

  bool get isReady => _isReady;
}
