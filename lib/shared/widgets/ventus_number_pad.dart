import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';

/// On-screen decimal number pad (1–9, ".", 0, ⌫) used wherever an amount is
/// typed (expense sheet, currency converter), so the system keyboard never
/// has to push the layout around.
class VentusNumberPad extends StatelessWidget {
  const VentusNumberPad({
    super.key,
    required this.onKey,
    required this.onBackspace,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
    final colors = context.colors;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.5,
      children: [
        for (final k in keys)
          VentusTap(
            onTap: () {
              HapticFeedback.selectionClick();
              if (k == '⌫') {
                onBackspace();
              } else {
                onKey(k);
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surfaceSand,
                borderRadius: AppRadius.brMd,
              ),
              child: k == '⌫'
                  ? VentusIcon(
                      VentusIcons.arrowLeft,
                      size: 22,
                      color: colors.ink2,
                    )
                  : Text(
                      k,
                      style: TextStyle(
                        fontSize: AppFontSize.h2,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
