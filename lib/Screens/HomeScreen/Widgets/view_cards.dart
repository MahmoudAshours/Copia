import 'package:copia/Screens/AllPdfs/all_pdfs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your books',
            style: TextStyle(
                fontFamily: 'cormorant',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xffAAABAD)),
          ),
          Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AllPDFs())),
              child: Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                        fontFamily: 'cormorant',
                        color: Color(0xffF3BB84),
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Color(0xffF3BB84),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
