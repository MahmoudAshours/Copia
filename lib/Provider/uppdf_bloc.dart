import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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

  Future<Null> getPDF(context) async {
    try {
      final root = Directory('');

      String path = await FilesystemPicker.open(
        title: 'Open file',
        context: context,
        rootDirectory: root,
        fsType: FilesystemType.file,
        rootName: 'Downloads',
        folderIconColor: Colors.teal,
        allowedExtensions: [''],
        fileTileSelectMode: FileTileSelectMode.wholeTile,
      );
      // FilePickerResult _file = await FilePicker.platform.pickFiles(
      //   allowedExtensions: ['pdf'],
      //   type: FileType.custom,
      // );

      _pdf = path;
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
      final path = await getApplicationDocumentsDirectory();

      final File _copiaImage =
          await _image.copy('${path.path}/${basename(_image.path)}');
      _imageUploaded = _copiaImage.path;

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
