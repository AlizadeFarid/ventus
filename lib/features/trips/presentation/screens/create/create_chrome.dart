import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_context_extension.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/l10n/l10n_extension.dart';
import '../../../../../core/theme/app_typography.dart';

/// Round 42px chrome button (close / back) shared by the Create Trip steps.
class CreateRoundButton extends StatelessWidget {
  const CreateRoundButton({super.key, required this.icon, this.onTap});

  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: context.l10n.back,
      padding: const EdgeInsets.all(1),
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: context.shadows.card,
        ),
        child: VentusIcon(icon, size: 20, color: colors.ink),
      ),
    );
  }
}

/// Step header: leading back/close button + 3-segment progress + "n/total".
class CreateStepHeader extends StatelessWidget {
  const CreateStepHeader({
    super.key,
    required this.step,
    this.total = 3,
    required this.onLead,
    this.leadIsClose = false,
  });

  final int step;
  final int total;
  final VoidCallback onLead;
  final bool leadIsClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Row(
        children: [
          CreateRoundButton(
            icon: leadIsClose ? VentusIcons.close : VentusIcons.arrowLeft,
            onTap: onLead,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < total; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i < step ? colors.primary : colors.lineStrong,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 30,
            child: Text(
              '$step/$total',
              textAlign: TextAlign.right,
              style: context.typography.sm.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.muted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered title header used by the final Review screen (no progress bar).
class CreateTitleHeader extends StatelessWidget {
  const CreateTitleHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Row(
        children: [
          CreateRoundButton(icon: VentusIcons.arrowLeft, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.typography.body.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

/// Step scaffold: header, scrolling body, and a pinned footer with a top rule.
class CreateStepScaffold extends StatelessWidget {
  const CreateStepScaffold({
    super.key,
    required this.header,
    required this.body,
    this.footer,
  });

  final Widget header;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        header,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            child: body,
          ),
        ),
        if (footer != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: context.shadows.card,
            ),
            child: footer,
          ),
      ],
    );
  }
}

/// Large step title with an optional subtitle (prototype `Title`).
class CreateStepTitle extends StatelessWidget {
  const CreateStepTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSize.h1,
              height: 32 / 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.84,
            ).copyWith(color: colors.ink),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: AppFontSize.body,
                height: 21 / 15,
                color: colors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small uppercase section label (prototype `SectionLabel`).
class CreateSectionLabel extends StatelessWidget {
  const CreateSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: AppFontSize.caption,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.72,
          color: context.colors.muted,
        ),
      ),
    );
  }
}
