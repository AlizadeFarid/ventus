import 'package:flutter/material.dart';
import '../../core/theme/app_overlay.dart';

import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import '../../core/theme/app_typography.dart';

/// Translucent white pill for text over a photo (trip cover chips).
class VentusGlassPill extends StatelessWidget {
  const VentusGlassPill({super.key, required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppOverlay.glassFill,
        borderRadius: AppRadius.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VentusIcon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
