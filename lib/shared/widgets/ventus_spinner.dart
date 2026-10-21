import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';

/// The one loading spinner. Coral by default; pass [color] when it sits on a
/// filled surface (e.g. on-primary inside a button).
class VentusSpinner extends StatelessWidget {
  const VentusSpinner({super.key, this.size = 28, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size <= 16 ? 2 : 2.5,
        color: color ?? context.colors.primary,
      ),
    );
  }
}
