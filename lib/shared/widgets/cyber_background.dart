import 'package:flutter/material.dart';

class CyberBackground extends StatelessWidget {
  const CyberBackground({
    super.key,
    this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget? child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topA = isDark ? const Color(0xFF07101F) : const Color(0xFFDFF3FF);
    final topB = isDark ? const Color(0xFF0E1E35) : const Color(0xFFEFFFF8);
    final bottom = isDark ? const Color(0xFF070D16) : const Color(0xFFF7FBFF);
    final gridColor = isDark
        ? const Color(0xFF6EE8FF).withValues(alpha: 0.08)
        : const Color(0xFF2CA6DA).withValues(alpha: 0.08);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [topA, topB, bottom],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -70,
          child: _GlowBlob(
            color: const Color(0xFF19D8FF).withValues(alpha: 0.2),
            size: 280,
          ),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: _GlowBlob(
            color: const Color(0xFFFFC857).withValues(alpha: 0.14),
            size: 340,
          ),
        ),
        IgnorePointer(child: CustomPaint(painter: _GridPainter(gridColor))),
        if (child != null) Padding(padding: padding, child: child!),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.05, 1],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
