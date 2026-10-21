import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/auth_controller.dart';
import '../../../../core/theme/app_typography.dart';

/// "Check your inbox" screen, shown after sign-up when the backend requires
/// email confirmation (no session yet). The user confirms via the emailed link,
/// then returns to sign in. Offers a resend in case the email didn't arrive.
class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  Future<void> _resend(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .resendConfirmation(email);
    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, l10n.verifyEmailResent);
    } else {
      showVentusError(
        context,
        l10n.somethingWentWrong,
        onRetry: () => _resend(context, ref),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.typography;
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: const VentusAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s6,
            AppSpacing.s6,
            AppSpacing.s6,
            AppSpacing.s5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: VentusIcon(
                  VentusIcons.mail,
                  size: 30,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.s5),
              Text(
                l10n.verifyEmailTitle,
                style: type.h1.copyWith(
                  fontSize: AppFontSize.h1,
                  height: 31 / 27,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              Text(
                l10n.verifyEmailBody(email),
                style: type.body.copyWith(height: 23 / 16, color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.s3),
              Text(
                l10n.verifyEmailSpamNote,
                style: type.caption.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.s6),
              VentusButton(
                label: l10n.verifyEmailResend,
                variant: VentusButtonVariant.secondary,
                full: true,
                loading: loading,
                iconLeft: VentusIcons.mail,
                onPressed: () => _resend(context, ref),
              ),
              const Spacer(),
              VentusButton(
                label: l10n.verifyEmailSignIn,
                full: true,
                onPressed: () => context.go(AppRoutes.signIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
