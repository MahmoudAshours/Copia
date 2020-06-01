import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return GestureDetector(
      onTap: () => _bloc.getPDF(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 10.0),
          FaIcon(
            FontAwesomeIcons.filePdf,
            color: Colors.redAccent,
            size: 30,
          ),
          SizedBox(width: 20.0),
          _bloc.pdfUploaded
              ? FaIcon(FontAwesomeIcons.solidCheckCircle, color: Colors.green)
              : Container()
        ],
      ),
    );
  }
}
