import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReadSvg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: 100,
          height: 100,
          child: SvgPicture.asset(
            'assets/images/shelves.svg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
