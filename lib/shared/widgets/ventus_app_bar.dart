import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Top navigation row with an optional circular back button and trailing
/// action (prototype `PhoneFrame.jsx` → AppBar).
class VentusAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VentusAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.onBack,
    this.action,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          6,
          AppSpacing.screen,
          10,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 42,
              child: showBack
                  ? VentusTap(
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          boxShadow: context.shadows.card,
                        ),
                        child: VentusIcon(
                          VentusIcons.arrowLeft,
                          size: 20,
                          color: colors.ink,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Center(
                child: title == null
                    ? null
                    : Text(
                        title!,
                        style: context.typography.h3.copyWith(
                          fontSize: AppFontSize.body,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 42,
              child: Align(alignment: Alignment.centerRight, child: action),
            ),
          ],
        ),
      ),
    );
  }
}
