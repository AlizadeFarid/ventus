import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/widgets.dart';

/// Centered "question + action" footer used across the auth screens
/// (prototype `Auth.jsx` → Foot). The action is tappable and primary-colored.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;

    return VentusTap(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: '$question ',
          style: type.sm.copyWith(color: colors.muted),
          children: [
            TextSpan(
              text: action,
              style: type.sm.copyWith(
                color: context.primaryFill,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
