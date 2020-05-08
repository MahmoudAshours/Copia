import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    return GestureDetector(
      onTap: () => _bloc.getImageFromGallery(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Upload an image preview'),
          SizedBox(height: 10.0),
          Icon(Icons.image),
        ],
      ),
    );
  }
}
