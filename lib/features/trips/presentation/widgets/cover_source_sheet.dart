import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';

/// What the user chose in the cover-photo source sheet.
enum CoverSourceAction { camera, gallery, remove }

/// Bottom sheet offering Camera / Library / (optional) Remove for a trip cover.
/// Shared by the Create-flow review step and the Trip Hub. Returns the chosen
/// [CoverSourceAction], or null if dismissed.
Future<CoverSourceAction?> showCoverSourceSheet(
  BuildContext context, {
  required bool canRemove,
}) {
  return showVentusSheet<CoverSourceAction>(
    context,
    isScrollControlled: false,
    builder: (_) => _CoverSourceSheet(canRemove: canRemove),
  );
}

class _CoverSourceSheet extends StatelessWidget {
  const _CoverSourceSheet({required this.canRemove});

  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VentusSheetHandle(),
            _Row(
              icon: VentusIcons.camera,
              label: l10n.avatarTakePhoto,
              onTap: () => Navigator.of(context).pop(CoverSourceAction.camera),
            ),
            _Row(
              icon: VentusIcons.image,
              label: l10n.avatarChooseLibrary,
              onTap: () => Navigator.of(context).pop(CoverSourceAction.gallery),
            ),
            if (canRemove) ...[
              _Row(
                icon: VentusIcons.trash,
                label: l10n.coverRemove,
                danger: true,
                onTap: () =>
                    Navigator.of(context).pop(CoverSourceAction.remove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.ink;
    return VentusTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            VentusIcon(icon, size: 20, color: fg),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
