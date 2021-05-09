import 'package:animate_do/animate_do.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UploadFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10.0),
        FadeInUp(
          child: TextButton(
            onPressed: () => _bloc.getPDF(context),
            child: FaIcon(
              FontAwesomeIcons.filePdf,
              color: Colors.redAccent,
              size: 30,
            ),
          ),
        ),
        FadeInUp(
          delay: Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Upload your pdf',
              style: TextStyle(
                fontFamily: 'cormorant',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xffAAABAD),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.0),
        _bloc.pdfUploaded
            ? FaIcon(FontAwesomeIcons.solidCheckCircle,
                color: Color(0xff9D7B38))
            : Container()
      ],
    );
  }
}
