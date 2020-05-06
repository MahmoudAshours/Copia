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
          decoration: InputDecoration(
            hintText: 'Enter PDF title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
