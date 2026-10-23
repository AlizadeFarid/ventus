import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';

/// The "continue with Google / Apple" pair (prototype `Auth.jsx` → SocialRow).
///
/// OAuth is UI-only for now; the callbacks currently surface a "coming soon"
/// message via the screens.
class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key, this.onGoogle, this.onApple});

  final VoidCallback? onGoogle;
  final VoidCallback? onApple;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VentusButton(
            label: 'Google',
            variant: VentusButtonVariant.tonal,
            size: VentusButtonSize.md,
            iconLeft: VentusIcons.google,
            full: true,
            onPressed: onGoogle,
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: VentusButton(
            label: 'Apple',
            variant: VentusButtonVariant.tonal,
            size: VentusButtonSize.md,
            iconLeft: VentusIcons.apple,
            iconColor: context.colors.ink,
            full: true,
            onPressed: onApple,
          ),
        ),
      ],
    );
  }
}
