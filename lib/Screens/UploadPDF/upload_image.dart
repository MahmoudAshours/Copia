import 'package:animate_do/animate_do.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:neumorphic/neumorphic.dart' as Neu;

class UploadImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FadeInUp(
          animate: true,
          child: Neu.NeuButton(
            onPressed: () => _bloc.getImageFromGallery(),
            decoration: Neu.NeumorphicDecoration(
                color: Color(0xff26292D),
                borderRadius: BorderRadius.circular(30)),
            child: FaIcon(
              FontAwesomeIcons.fileImage,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ),
        FadeInUp(
          delay: Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Upload your Image',
                style: TextStyle(
                    fontFamily: 'cormorant',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffAAABAD))),
          ),
        ),
        SizedBox(width: 20.0),
        _bloc.ifImageUploaded
            ? FaIcon(FontAwesomeIcons.solidCheckCircle, color: Colors.green)
            : Container()
      ],
    );
  }
}
