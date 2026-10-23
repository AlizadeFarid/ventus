import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Privacy & security settings, reached from the Profile menu.
///
/// Groups the device PIN lock, account actions (change password, sign out) and
/// a danger zone (account deletion). No prototype design existed for this
/// screen — it follows the house card/section style.
class PrivacySecurityScreen extends ConsumerWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final hasPassword =
        ref.watch(hasPasswordLoginProvider).asData?.value ?? true;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.menuPrivacySecurity),
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
              VentusSectionLabel(l10n.privacySectionAppLock),
              VentusCard(
                children: [
                  _Row(
                    icon: VentusIcons.lock,
                    label: l10n.privacyChangePin,
                    sub: l10n.privacyChangePinSub,
                    onTap: () => context.push(AppRoutes.changePin),
                    last: true,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              VentusSectionLabel(l10n.privacySectionAccount),
              VentusCard(
                children: [
                  _Row(
                    icon: VentusIcons.shield,
                    // A Google/Apple account has no password yet, so the row
                    // offers to set one rather than to change something that
                    // does not exist.
                    label: hasPassword
                        ? l10n.changePasswordTitle
                        : l10n.setPasswordTitle,
                    sub: hasPassword
                        ? l10n.privacyChangePasswordSub
                        : l10n.setPasswordNote,
                    onTap: () => context.push(AppRoutes.changePassword),
                    last: true,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              VentusSectionLabel(l10n.privacySectionDanger),
              VentusCard(
                children: [
                  _Row(
                    icon: VentusIcons.trash,
                    label: l10n.privacyDeleteAccount,
                    sub: l10n.privacyDeleteAccountSub,
                    danger: true,
                    showChevron: false,
                    onTap: () => _confirmDelete(context, ref),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    final confirmed = await confirmVentusAction(
      context,
      title: l10n.deleteAccountTitle,
      body: l10n.deleteAccountBody,
      confirmLabel: l10n.deleteConfirm,
      destructive: true,
    );

    if (!confirmed || !context.mounted) return;

    final router = GoRouter.of(context);
    final deletedText = l10n.accountDeleted;
    final failedText = l10n.somethingWentWrong;

    final ok = await ref.read(authControllerProvider.notifier).deleteAccount();

    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, deletedText);
    } else {
      showVentusError(context, failedText);
    }
    // On success the session is cleared; the router's auth guard returns the
    // user to the welcome flow, but route explicitly so it's immediate.
    if (ok) router.go(AppRoutes.welcome);
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.sub,
    this.danger = false,
    this.showChevron = true,
    this.last = false,
  });

  final String icon;
  final String label;
  final String? sub;
  final VoidCallback onTap;
  final bool danger;
  final bool showChevron;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.ink;
    final iconFg = danger ? colors.danger : colors.ink2;

    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            VentusLeadIcon(icon, color: iconFg),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sub!,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 12),
              VentusIcon(
                VentusIcons.chevronRight,
                size: 18,
                color: colors.muted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
