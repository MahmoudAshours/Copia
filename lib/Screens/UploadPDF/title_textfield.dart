import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PdfTitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 200,
        child: TextField(
          onChanged: (String title) => _bloc.pdfTitle = title,
          style: TextStyle(
              color: Color(0xff45B696),
              fontFamily: 'cormorant',
              fontSize: 21,
              fontWeight: FontWeight.w700),
          decoration: InputDecoration(
              hintText: 'Enter PDF title',
              hintStyle: TextStyle(
                color: Color(0xff45B696),
                fontFamily: 'cormorant',
              ),
              contentPadding: EdgeInsets.all(4),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
