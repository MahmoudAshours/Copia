import 'package:flutter/material.dart';

class UploadPdfTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 130.0, left: 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Color(0xffECB279),
                borderRadius: BorderRadius.circular(100)),
            child: Text(
              'Upload your PDF',
              style:  TextStyle(fontFamily: 'cormorant', fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
