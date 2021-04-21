import 'package:copia/Screens/UploadPDF/add_button.dart';
import 'package:copia/Screens/UploadPDF/book_svg.dart';
import 'package:copia/Screens/UploadPDF/read_svg.dart';
import 'package:copia/Screens/UploadPDF/title_textfield.dart';
import 'package:copia/Screens/UploadPDF/upload_file.dart';
import 'package:copia/Screens/UploadPDF/upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26292D),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.6,
            child: SvgPicture.asset(
              'assets/images/eye.svg',
              fit: BoxFit.fitHeight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UploadImage(),
                  ),
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
