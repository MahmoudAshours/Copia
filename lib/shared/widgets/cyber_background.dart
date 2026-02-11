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
    final top = isDark ? const Color(0xFF231E1A) : const Color(0xFFFAF8F3);
    final bottom = isDark ? const Color(0xFF1B1714) : const Color(0xFFF4F1EA);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [top, bottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child == null
          ? const SizedBox.shrink()
          : Padding(padding: padding, child: child!),
    );
  }
}
