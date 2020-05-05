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

  var imageUploaded = UploadImage.notUploading;
  var pdfUploaded = UploadPDF.notUploading;

  Future<Null> getPDF() async {
    try {
      File _file = await FilePicker.getFile(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );
      List<int> pdfBytes = _file.readAsBytesSync();
      String pdf = base64Encode(pdfBytes);
      _pdf = pdf;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }

  Future<Null> getImageFromGallery() async {
    try {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      List<int> imageBytes = _image.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      _imageUploaded = imageB64;
      notifyListeners();
    } catch (e) {
      return null;
    }
  }
}

enum UploadImage { notUploading, uploading }
enum UploadPDF { notUploading, uploading }
