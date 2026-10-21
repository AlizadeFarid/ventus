import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';

/// Which legal document to render.
enum LegalDoc { terms, privacy }

/// A simple, self-contained legal document screen (Terms / Privacy), reached
/// from the sign-up consent links. Content lives in l10n and closes with a
/// contact note.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;
    final sections = _sectionsFor(doc, l10n);

    return Scaffold(
      appBar: VentusAppBar(
        title: doc == LegalDoc.terms
            ? l10n.legalTermsTitle
            : l10n.legalPrivacyTitle,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s6,
            AppSpacing.s4,
            AppSpacing.s6,
            AppSpacing.s8,
          ),
          children: [
            Text(
              l10n.legalUpdated,
              style: type.caption.copyWith(color: colors.muted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              doc == LegalDoc.terms
                  ? l10n.legalTermsIntro
                  : l10n.legalPrivacyIntro,
              style: type.body.copyWith(height: 23 / 16, color: colors.ink2),
            ),
            const SizedBox(height: AppSpacing.s6),
            for (final s in sections) ...[
              Text(s.$1, style: type.h3),
              const SizedBox(height: AppSpacing.s2),
              Text(
                s.$2,
                style: type.body.copyWith(height: 23 / 16, color: colors.ink2),
              ),
              const SizedBox(height: AppSpacing.s5),
            ],
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: BoxDecoration(
                color: colors.surfaceSand,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                l10n.legalContact,
                style: type.sm.copyWith(color: colors.ink2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<(String, String)> _sectionsFor(LegalDoc doc, AppLocalizations l10n) {
    return switch (doc) {
      LegalDoc.terms => [
        (l10n.legalTermsS1Title, l10n.legalTermsS1Body),
        (l10n.legalTermsS2Title, l10n.legalTermsS2Body),
        (l10n.legalTermsS3Title, l10n.legalTermsS3Body),
        (l10n.legalTermsS4Title, l10n.legalTermsS4Body),
      ],
      LegalDoc.privacy => [
        (l10n.legalPrivacyS1Title, l10n.legalPrivacyS1Body),
        (l10n.legalPrivacyS2Title, l10n.legalPrivacyS2Body),
        (l10n.legalPrivacyS3Title, l10n.legalPrivacyS3Body),
        (l10n.legalPrivacyS4Title, l10n.legalPrivacyS4Body),
      ],
    };
  }
}
