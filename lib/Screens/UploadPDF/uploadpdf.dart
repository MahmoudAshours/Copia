import 'package:copia/Screens/UploadPDF/add_button.dart';
import 'package:copia/Screens/UploadPDF/book_svg.dart';
import 'package:copia/Screens/UploadPDF/circle_svg.dart';
import 'package:copia/Screens/UploadPDF/read_svg.dart';
import 'package:copia/Screens/UploadPDF/title_textfield.dart';
import 'package:copia/Screens/UploadPDF/upload_file.dart';
import 'package:copia/Screens/UploadPDF/upload_image.dart';
import 'package:copia/Screens/UploadPDF/upload_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEED),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          CircleSvg(alignment: Alignment.topRight),
          CircleSvg(alignment: Alignment.bottomLeft),
          UploadPdfTitle(),
          BookSvg(),
          ReadSvg(),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PdfTitleTextField(),
                  SizedBox(height: 10.0),
                  UploadFile(),
                  UploadImage(),
                  SizedBox(height: 30),
                  UploadButton()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
