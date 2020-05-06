import 'package:flutter/material.dart';

class CircleSvg extends StatelessWidget {
  final Alignment alignment;
  CircleSvg({@required this.alignment});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: 0.8,
        child: SizedBox(
          width: 50,
          height: 200,
          child: CustomPaint(
            painter: Circle(),
          ),
        ),
      ),
    );
  }
}

class Circle extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color(0xff584846)
    ..strokeWidth = 2;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, 200, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
