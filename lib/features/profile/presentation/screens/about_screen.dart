import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// About: the mark, the version, one line on what Ventus is, and the legal
/// documents.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.menuAbout),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            24,
            AppSpacing.screen,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const VentusMark(size: 76, radius: 22),
                    const SizedBox(height: 16),
                    Text(
                      'Ventus',
                      style: context.typography.h1.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 6),
                    FutureBuilder<PackageInfo>(
                      future: _info,
                      builder: (context, snapshot) {
                        final info = snapshot.data;
                        return Text(
                          info == null
                              ? ''
                              : '${info.version} (${info.buildNumber})',
                          style: context.typography.sm.copyWith(
                            color: colors.muted,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.aboutTagline,
                      textAlign: TextAlign.center,
                      style: context.typography.body.copyWith(
                        color: colors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              VentusSectionLabel(l10n.aboutLegalSection),
              VentusCard(
                children: [
                  _LegalRow(
                    label: l10n.legalTermsTitle,
                    onTap: () => context.push(AppRoutes.terms),
                  ),
                  _LegalRow(
                    label: l10n.legalPrivacyTitle,
                    onTap: () => context.push(AppRoutes.privacy),
                    last: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalRow extends StatelessWidget {
  const _LegalRow({
    required this.label,
    required this.onTap,
    this.last = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
            ),
            VentusIcon(VentusIcons.chevronRight, size: 18, color: colors.muted),
          ],
        ),
      ),
    );
  }
}
