import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          child: SvgPicture.asset(
            'assets/images/book.svg',
            fit: BoxFit.cover,
          ),
        ),
        Text(
          'There is no books yet..Add one!',
          style:  TextStyle(fontFamily: 'cormorant',
              fontSize: 21, fontWeight: FontWeight.w800, color: Colors.blue),
        )
      ],
    );
  }
}
