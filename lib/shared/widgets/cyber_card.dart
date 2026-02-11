import 'dart:ui';

import 'package:flutter/material.dart';

class CyberCard extends StatelessWidget {
  const CyberCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: scheme.surface.withValues(alpha: 0.64),
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.surface.withValues(alpha: 0.82),
                    scheme.surface.withValues(alpha: 0.56),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
