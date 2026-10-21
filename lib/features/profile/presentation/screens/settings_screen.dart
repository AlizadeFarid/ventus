import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/app_locales.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Appearance + Language settings, opened from the Profile gear.
///
/// Both controls are already backed by providers ([themeModeProvider],
/// [localeProvider]); this screen just exposes them.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            8,
            AppSpacing.screen,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VentusSectionLabel(l10n.appearance),
              VentusCard(
                children: [
                  _SelectRow(
                    label: l10n.themeSystem,
                    selected: themeMode == ThemeMode.system,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .set(ThemeMode.system),
                  ),
                  _SelectRow(
                    label: l10n.themeLight,
                    selected: themeMode == ThemeMode.light,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .set(ThemeMode.light),
                  ),
                  _SelectRow(
                    label: l10n.themeDark,
                    selected: themeMode == ThemeMode.dark,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .set(ThemeMode.dark),
                    last: true,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              VentusSectionLabel(l10n.language),
              VentusCard(
                children: [
                  _SelectRow(
                    label: l10n.systemDefault,
                    selected: locale == null,
                    onTap: () => ref.read(localeProvider.notifier).set(null),
                  ),
                  _SelectRow(
                    label: 'English',
                    selected: locale?.languageCode == 'en',
                    onTap: () =>
                        ref.read(localeProvider.notifier).set(AppLocales.en),
                  ),
                  _SelectRow(
                    label: 'Azərbaycan',
                    selected: locale?.languageCode == 'az',
                    onTap: () =>
                        ref.read(localeProvider.notifier).set(AppLocales.az),
                  ),
                  _SelectRow(
                    label: 'Türkçe',
                    selected: locale?.languageCode == 'tr',
                    onTap: () =>
                        ref.read(localeProvider.notifier).set(AppLocales.tr),
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

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.last = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
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
            if (selected)
              VentusIcon(VentusIcons.check, size: 20, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
