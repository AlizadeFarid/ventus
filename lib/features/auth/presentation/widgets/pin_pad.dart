import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Sentinel returned by [PinKeypad] for the delete key.
const String kPinDelete = 'del';

/// Row of progress dots for PIN entry (prototype `Auth.jsx` → Dots).
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.total = 4});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final on = i < filled;
        return Container(
          margin: EdgeInsets.only(right: i == total - 1 ? 0 : 16),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? colors.primary : Colors.transparent,
            border: Border.all(
              color: on ? colors.primary : colors.lineStrong,
              width: 1.8,
            ),
          ),
        );
      }),
    );
  }
}

/// 3×4 numeric keypad (prototype `Auth.jsx` → Keypad).
///
/// Emits the tapped digit, or [kPinDelete] for backspace, through [onKey].
class PinKeypad extends StatelessWidget {
  const PinKeypad({super.key, required this.onKey});

  final ValueChanged<String> onKey;

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', kPinDelete],
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in _keys)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    for (final key in row)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _Key(value: key, onKey: onKey),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.value, required this.onKey});

  final String value;
  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox(height: 60);

    final colors = context.colors;
    final isDelete = value == kPinDelete;

    return VentusTap(
      onTap: () => onKey(value),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDelete ? Colors.transparent : colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: isDelete ? null : context.shadows.card,
        ),
        child: isDelete
            ? VentusIcon(VentusIcons.arrowLeft, size: 24, color: colors.muted)
            : Text(
                value,
                style: context.typography.h2.copyWith(
                  fontSize: AppFontSize.h1,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
      ),
    );
  }
}
