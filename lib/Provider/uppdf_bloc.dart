import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class UploadPdfBloc with ChangeNotifier {
  var imageUploaded = UploadImage.notUploading;

  Future<String> getImageFromGallery() async {
    try {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      List<int> imageBytes = _image.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      return imageB64;
    } catch (e) {
      return null;
    }
  }
}

enum UploadImage { notUploading, uploading }
