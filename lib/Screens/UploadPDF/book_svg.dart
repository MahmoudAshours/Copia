import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BookSvg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 100,
          height: 100,
          child: SvgPicture.asset(
            'assets/images/books.svg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
