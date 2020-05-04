import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastOpened extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Last book opened',
              style: GoogleFonts.cormorant(
                  fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(),
          Opacity(
            opacity: 0.4,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff584846),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[Text('book!')],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
