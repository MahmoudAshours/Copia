import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Upload a image preview'),
        SizedBox(height: 10.0),
        IconButton(
            icon: Icon(Icons.image),
            onPressed: () => _bloc.getImageFromGallery())
      ],
    );
  }
}
