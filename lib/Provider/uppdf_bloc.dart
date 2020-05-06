import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class UploadPdfBloc with ChangeNotifier {
  String _pdfTitle;
  String _imageUploaded;
  String _pdf;
  set pdfTitle(String title) => _pdfTitle = title;
  String get getPdfTitle => _pdfTitle;
  String get getImage => _imageUploaded;
  String get getPdf => _pdf;

  Future<Null> getPDF() async {
    try {
      File _file = await FilePicker.getFile(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );
      _pdf = _file.path;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }

  Future<Null> getImageFromGallery() async {
    try {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _imageUploaded = _image.path;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }
}
