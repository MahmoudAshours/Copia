import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            style: GoogleFonts.cormorant(
                fontSize: 30,
                fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              Text(
                'View all',
                style: TextStyle(
                    fontFamily: 'cormorant', color: Color(0xffF3BB84)),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Color(0xffF3BB84),
              )
            ],
          ),
        ],
      ),
    );
  }
}
