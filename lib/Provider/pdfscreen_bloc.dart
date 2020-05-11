import 'package:flutter/foundation.dart';

class PDFScreenBloc with ChangeNotifier {
  String _path = '';
  int _currentPage;
  bool _isReady = false;
  String _errorMessage = '';

  set path(String path) {
    _path = path;
    notifyListeners();
  }

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

  String get path => _path;

  int get currpage => _currentPage;

  String get getError => _errorMessage;

  bool get isReady => _isReady;
}
