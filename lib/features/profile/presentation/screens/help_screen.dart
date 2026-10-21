import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Help: short questions and answers, one open at a time.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final faq = <(String, String)>[
      (l10n.helpQ1, l10n.helpA1),
      (l10n.helpQ2, l10n.helpA2),
      (l10n.helpQ3, l10n.helpA3),
      (l10n.helpQ4, l10n.helpA4),
      (l10n.helpQ5, l10n.helpA5),
      (l10n.helpQ6, l10n.helpA6),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.menuHelp),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            8,
            AppSpacing.screen,
            24,
          ),
          itemCount: faq.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _FaqCard(
            question: faq[i].$1,
            answer: faq[i].$2,
            open: _open == i,
            onTap: () => setState(() => _open = _open == i ? null : i),
          ),
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.question,
    required this.answer,
    required this.open,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          boxShadow: context.shadows.card,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: AppFontSize.body,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: open ? 0.25 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: VentusIcon(
                      VentusIcons.chevronRight,
                      size: 18,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
              if (open) ...[
                const SizedBox(height: 10),
                Text(
                  answer,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    height: 1.5,
                    color: colors.ink2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
