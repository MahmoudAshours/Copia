import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class UploadPdfBloc with ChangeNotifier {
  String _pdfTitle;
  String _imageUploaded;
  String _pdf;
  bool _pdfUploaded = false;
  bool _ifImageUploaded = false;
  set pdfTitle(String title) => _pdfTitle = title;
  String get getPdfTitle => _pdfTitle;
  String get getImage => _imageUploaded;
  String get getPdf => _pdf;
  bool get pdfUploaded => _pdfUploaded;
  bool get ifImageUploaded => _ifImageUploaded;

  Future<Null> getPDF() async {
    try {
      File _file = await FilePicker.getFile(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );
      _pdf = _file.path;
      _pdfUploaded = true;
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Null> getImageFromGallery() async {
    try {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _imageUploaded = _image.path;
      _ifImageUploaded = true;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }

  void nullify() {
    _pdfTitle = null;
    _pdf = null;
    _pdfUploaded = false;
    _imageUploaded = null;
    _ifImageUploaded = false;
  }
}
